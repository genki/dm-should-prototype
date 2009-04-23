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

    def self.doc(new_value=nil)
      @doc = new_value if new_value.is_a? String
      @doc = "should " + @name.to_s.gsub("_", " ") unless @doc
      @doc
    end

    def doc
      self.class.doc
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

    attr_reader :scope

    def initialize(property, options={})
      super property
      @options = options
      setup_scopes
    end

    def setup_scopes
      @scopes = @options[:scope] ?
        Array(@options[:scope]).map { |sym| @property.model.properties[sym] } :
        []
    end


    def satisfy?(resource)
      conditions = { property.name => read_attribute(resource) }
      conditions.merge! :id.not => resource.id unless resource.new_record?

      @scopes.each do |scope|
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

class String
  def blank?
    self.gsub("　", " ").strip.empty?
  end
end
