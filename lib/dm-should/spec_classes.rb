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

    def read_attribute(resource)
      property.get(resource)
    end

  end

  class BePresent < SpecBase
    name :be_present
    predicates do
      def be_present
        BePresent.new(@property)
      end
    end


    def ensure(resource)
      resource.errors.add self unless satisfy?(resource)
    end

    def satisfy?(resource)
      read_attribute(resource).present?
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


