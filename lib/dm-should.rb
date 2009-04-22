require 'rubygems'

# gem 'dm-core', '0.9.11'
require 'dm-core'

dir = Pathname(__FILE__).dirname.expand_path / 'dm-should'

require dir / "version"
require dir / "model"
require dir / "spec_collector"
require dir / "spec_collection"
require dir / "spec_classes"


module DataMapper

  class Property
  end


  module Resource

    def valid?
      errors.clear!
      ensure_specs
      errors.empty?
    end
    alias_method :satisfy?, :valid?


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

    def each(&block)
      @errors.each(&block)
    end

    include Enumerable

  end

end

