module DataMapper::Should
  
  class SpecBase

    attr_reader :property
    include ::Extlib::Assertions

    def self.name(new_value=nil)
      @name = new_value if new_value.is_a? Symbol
      @name
    end

    def self.predicates(&block)
      DataMapper::Should::AvailablePredicates.module_eval &block if block
    end

    def initialize(property)
      @property = property
      setup_translation_scope
      setup_default_values_for_translation
    end

    def read_attribute(resource, options={})
      typecasted = property.get(resource)
      options[:before_typecast] ?
        property.get_before_typecast_value!(resource) :
        typecasted
    end

    # NOTE: All spec class could be ensured with this form?
    def ensure(resource)
      resource.errors.add self unless satisfy?(resource)
    end

    def satisfy?(resource)
      raise "implement #satisfy? method in each of subclasses"
    end

    def doc(additional_values={})
      values = default_values_for_translation
      values.update(additional_values) 
      Translation.translate(translation_scope, values)
    end

    def setup_default_values_for_translation
      @default_values_for_translation = { :field => field }
    end
    private :setup_default_values_for_translation
    attr_reader :default_values_for_translation

    def setup_translation_scope
      @translation_scope = self.class.name.to_s
    end
    private :setup_translation_scope
    attr_reader :translation_scope

    def field
      [@property.model, @property.name].map { |x| x.to_s }.join(".") 
    end

    def inspect
      "\#<#{self.class} #{doc.inspect} >"
    end

  end

  class BePresent < SpecBase
    name :be_present
    predicates do
      def be_present
        BePresent.new(@property)
      end
    end


    def satisfy?(resource)
      read_attribute(resource).present?
    end

  end

  class BePositiveInteger < SpecBase
    name :be_positive_integer
    predicates do
      def be_positive_integer
        BePositiveInteger.new(@property)
      end
    end

    # allow only positive integers.
    def satisfy?(resource)
      value = read_attribute(resource, :before_typecast => true)
      return true if property.nullable? and value.nil?
      value.to_s.match(/^\+?[0-9]+$/) != nil
    end

  end

  class BeInteger < SpecBase
    name :be_integer
    predicates do
      def be_integer
        BeInteger.new(@property)
      end
    end

    # allow both positive and negative integers.
    def satisfy?(resource)
      value = read_attribute(resource, :before_typecast => true)
      return true if property.nullable? and value.nil?
      value.to_s.match(/^[\+-]?[0-9]+$/) != nil
    end

  end

  class BeUnique < SpecBase
    name :be_unique
    predicates do
      def be_unique(options={})
        BeUnique.new(@property, options)
      end
    end

    attr_reader :scopes 

    def initialize(property, options={})
      @property = property
      @options = options
      setup_scopes_of_uniqueness
      setup_translation_scope
      setup_default_values_for_translation
    end

      def setup_scopes_of_uniqueness
        @scopes = @options[:scope] ?
          Array(@options[:scope]).map { |sym| @property.model.properties[sym] } :
          []
      end
      private :setup_scopes_of_uniqueness

      def setup_translation_scope
        @translation_scope = (!scopes.empty?) ? 
          "be_unique_with_scopes" : "be_unique"
      end
      private :setup_translation_scope

      def setup_default_values_for_translation
        super
        @default_values_for_translation.update(:scopes => scope_list)
      end
      private :setup_default_values_for_translation


      def scope_list
        scopes.map { |s| s.name.to_s }.join(",")
      end
      private :scope_list


    # TODO: Should some unique index at the layer of database ensure this?
    # In other words, where and how could I hanlde the exception about unique 
    # index of a database?
    def satisfy?(resource)
      conditions = { property.name => read_attribute(resource) }
      conditions.merge! :id.not => resource.id unless resource.new_record?

      scopes.each do |scope|
        conditions.merge! scope.name => scope.get(resource)
      end

      property.model.first(conditions).nil?
    end


  end
end


# core ext for be_present
unless Object.respond_to? :present?
  class Object
    def present?
      !blank?
    end
  end
end

# manage multi-byte space
class String
  MULTIBYTE_SPACE = [0x3000].pack("U").freeze

  def blank?
    self.gsub(MULTIBYTE_SPACE, "").strip.empty?
  end
end
