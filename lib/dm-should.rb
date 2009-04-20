require 'rubygems'

# gem 'dm-core', '0.9.11'
require 'dm-core'

dir = Pathname(__FILE__).dirname.expand_path / 'dm-should'

module DataMapper
  module Model
    
    def property_with_spec(*args, &block)
      pro = property(*args)
      specs << Should::SpecCollector.collect(pro, block)
    end


    # define the :ensure_spec instance method
    def ensure_spec
      self.module_eval(specs.compiled_statement, __FILE__, __LINE__) 
    end


    # A Model class has A SpecCollection.
    def specs
      @specs = Should::SpecCollection.new(self) unless @specs
      @specs
    end

  end


  class Property
  end

  module Resource

    def valid?
      errors.empty?
    end


    def errors
      @errors = Should::Errors.new unless @errors
      @errors
    end

  end
end
require dir / "version"
require dir / "model"
require dir / "spec_collector"
require dir / "spec_collection"

# spec classes
module DataMapper::Should
  
  class SpecBase

    attr_accessor :property

    def self.name(new_value=nil)
      @name = new_value if new_value.is_a? Symbol
      @name
    end

  end

  # TODO: Next step is how to generate code to ensure spec.
  class BePresent < SpecBase
    name :be_present
  end
end


# core ext for be_present
unless Object.respond_to? :present?
  class Object
    def presnet?
      !blank?
    end
  end
end


# how record.errors could be?
module DataMapper::Should
  class Errors
    def empty?
      true
    end
  end
end

