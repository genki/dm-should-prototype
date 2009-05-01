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
      @model = @scope
      @scope = record
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


    TRANSLATION_SCOPE_PREFIX = "warn".freeze

    def error_message_scopes
      map { |spec| self.class.translation_scope spec }
    end

    # TODO: think about shorter good method name of this later.
    def error_message_scopes_each
      if block_given?
        each do |spec|
          scope = self.class.translation_scope spec
          actual = spec.read_attribute(record)
          yield scope, {:actual => actual.inspect, :field => spec.field } 
        end
      end
    end

    def error_messages 
      result = []
      error_message_scopes_each do |scope, assigns|
        result << Translation.translate(scope, assigns)
      end
      result
    end

  end

end

