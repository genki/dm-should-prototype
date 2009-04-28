module DataMapper::Should
  class Translation 

    cattr_accessor :translations
    self.translations = {
      :warn_like_rspec => {
        :be_present => "expected %{field} was present, got %{actual}",
        :be_unique  => "expected %{field} was unique, got %{actual}",
        :be_positive_integer => "expected %{field} was positive integer, got %{actual}"
      },

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
      :specdocs => {
        :be_present => "%{field} should be present",
        :"be_unique" => "%{field} should be unique",
        :"be_unique_with_scopes" => "%{field} should be unique (scope: %{scopes})",
        :be_positive_integer => "%{field} should be a positive number"
      }
    }.to_mash

    def self.translate(scope, values={})
      String.new(translations[:specdocs][scope]) % values
    end

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


