module DataMapper::Should
  class Translation 

    cattr_accessor :translations
    self.translations = {
      :warn_like_rails => {
        :be_present => "%{field} can't be blank", 
        :be_unique  => "%{actual} has already been taken",
        :be_positive_integer => "%{actual} is not a positive number"
      },

      :warn_like_dm_validations => {
        :be_present => "%{field} must not be blank",
        :be_unique  => "%{actual} is already taken",
        :be_positive_integer => "%{field} must be a positive number"
      },

      # TODO: should or must, which is better?
      # - %{field} should be present
      # - %{field} must be present
      :specdoc => {
        :be_present => "%{field} should be present",
        :be_unique => "%{field} should be unique",
        :be_unique_within_scopes => "%{field} should be unique (scope: %{scopes})",
        :be_positive_integer => "%{field} should be a positive number"
      },

      :warn => {
        :be_present => "expected for %{field} to be present, got %{actual}",
        :be_unique  => "expected for %{field} to be unique, but it wasn't",
        :be_positive_integer => "expected for %{field} to be positive integer, got %{actual}"
      }

    }.to_mash

  class << self

    # == arguments
    # @param <String, Symbol, DataMapper::Should::SpecClass> scope
    # @param <Hash, Mash>                                    assigns

    def translate(scope, assigns={})
      if scope.is_a?(SpecClass)
        String.new(raw(scope.translation_scope)) % scope.assigns.update(assigns)
      elsif raw_message =  raw(scope)
        String.new(raw_message) % assigns
      end
    end


    # == arguments
    # @param <String, Symbol, DataMapper::Should::SpecClass> scope 
    
    def raw(scope)
      return "" if scope.nil?
      scopes = normalize_scope(scope)
      lookup(scopes) or lookup(scopes.unshift("specdoc")) or ""
    end

    def lookup(array)
      array.inject(translations) do |result, k|
        if (x = result[k]).nil?
          return nil
        else
          x
        end
      end
    end


      # == returns
      # @return <Array> the array of normalized values
      # - scope
      # - model
      # - field
      def normalize_scope(scope)
        parts = scope.split(".") 

        model = nil
        field = nil
        result = []
      
        parts.each do |part|
          if part =~ /^[A-Z]/
            model = part
          elsif model and field.nil?
            field = part
          else
            result << part
          end
        end

        #TODO: model and field value is now ignored. support later.
        result
      end
      private :normalize_scope

  end # end of class << self
  end

  class String < ::String
    def %(args)
      if args.kind_of?(Hash)
        ret = dup
        args.each{|key, value| ret.gsub!(/%\{#{key}\}/, value.to_s)}
        ret
      else
        super
      end
    end
  end

end


