require 'rubygems'

# gem 'dm-core', '0.9.11'
require 'dm-core'

dir = Pathname(__FILE__).dirname.expand_path / 'dm-should'

module DataMapper

  class Property
  end


  module Resource

    def valid?
      errors.clear!
      ensure_specs
      errors.empty?
    end


    def errors
      @errors = Should::Errors.new unless @errors
      @errors
    end

    def ensure_specs
      self.class.specs.each do |spec|
        spec.ensure(self)
      end
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

    attr_reader :property
    include ::Extlib::Assertions

    def self.name(new_value=nil)
      @name = new_value if new_value.is_a? Symbol
      @name
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


# how record.errors could be?
module DataMapper::Should
  class Errors

    def initialize
      @errors = []
    end


    def empty?
      @errors.empty?
    end


    def add(spec)
      @errors << spec
    end


    def clear!
      @errors.clear
    end


    def to_a
      @errors.dup
    end

  end
end

