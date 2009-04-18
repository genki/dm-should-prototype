require 'rubygems'

# gem 'dm-core', '0.9.11'
require 'dm-core'

dir = Pathname(__FILE__).dirname.expand_path / 'dm-should'

module DataMapper
  module Model
    
    attr_reader :specs
    

    def property_with_spec(*args, &block)
      pro = property(*args)
      collect_specs(pro, block)
      define_ensure_specs_method(pro)
    end


    def collect_specs(pro, spec_proc)
      @specs = Should::SpecCollection.new(pro)
      @specs.collect spec_proc
    end

    def define_ensure_specs_method(pro)
      code =   "def ensure_specs\n"
      code <<  "end"
      pro.model.module_eval(code, __FILE__, __LINE__) 
    end

  end
end

module DataMapper
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

# how are specs collected ?
module DataMapper::Should

  class SpecCollection

    attr_reader :specs, :property

    def initialize(property)
      @property = property
      @specs = []
    end
    
    def collect(spec_proc)
      SpecCollector.collect(self, spec_proc)
      specs
    end

    def inspect
      specs.inspect
    end

    def to_ary
      specs.dup
    end


    class SpecCollector

      def self.collect(collection, spec_proc)
        obj = self.new(collection)
        obj.instance_eval &spec_proc if spec_proc.is_a? Proc
      end

      def initialize(collection)
        @collection = collection
        @specs = []
      end

      def should(spec)
        spec.property = @collection.property
        @collection.specs << spec
      end

      def be_present
        BePresent.new
      end
    end

  end
end

# spec classes
module DataMapper::Should
  
  class SpecBase

    attr_accessor :property

    def self.name(new_value=nil)
      @name = new_value if new_value.is_a? Symbol
      @name
    end

  end

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

