require 'rubygems'

# gem 'dm-core', '0.9.11'
require 'dm-core'

dir = Pathname(__FILE__).dirname.expand_path / 'dm-should'

require dir / "version"
require dir / "model"
require dir / "spec_collector"
require dir / "spec_collection"
require dir / "spec_classes"
require dir / "before_typecast"
require dir / "translation"


module DataMapper

  module Resource

    def valid?
      errors.clear!
      ensure_specs
      errors.empty?
    end
    alias_method :satisfy?, :valid?


    def errors
      @errors = Should::Errors.new(self) unless @errors
      @errors
    end

    def ensure_specs
      self.class.specs.each do |spec|
        spec.ensure(self)
      end
    end

    
    # TODO think carefully about :create and :update methods later. 
    def save_only_when_valid
      if valid?
        save_without_ensure
      else
        false
      end
    end
    alias_method :save_without_ensure, :save
    alias_method :save, :save_only_when_valid

  end
end

# how record.errors could be?
module DataMapper::Should
  class Errors < ModelSpecs

    alias_method :errors, :specs
    alias_method :errors_mash, :specs_mash
    alias_method :record, :scope

    attr_writer :specs_mash
    private :specs_mash=
    alias_method :errors_mash=, :specs_mash=


    def initialize(record)
      assert_kind_of "scope of Errors", record, DataMapper::Resource
      super record.class 
      @record = record
    end


    def empty?
      errors.empty?
    end


    def clear!
      errors.clear
      self.errors_mash = Mash.new
    end


    def each(&block)
      errors.each(&block)
    end

    include Enumerable

    cattr_accessor :default_doctype
    self.default_doctype = :warn_like_rspec

    def error_messages
      map { |spec| spec.doc }
    end


    TRANSLATION_SCOPE_PREFIX = "warn".freeze

    def error_message_scopes
      map { |spec| self.class.translation_scope spec }
    end

  end

end



