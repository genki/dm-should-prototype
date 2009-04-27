module DataMapper::Should
  class Translation 

    cattr_accessor :error_messages_like_rspec
    self.error_messages_like_rspec = {
      :be_present => "expected %{field} be present, but it was %{actual}",
      :be_unique  => "expected %{field} be unique, but it was %{actual}",
      :be_positive_integer => "expected %{field} be positive integer, but it was %{actual}"
    }.to_mash

    cattr_accessor :error_messages_like_rails
    self.error_messages_like_rails = {
      :be_present => "%{field} can't be blank", 
      :be_unique  => "%{actual} has already been taken",
      :be_positive_integer => "%{actual} is not a positive number"
    }

    cattr_accessor :error_messages_like_dm_validations
    self.error_messages_like_dm_validations = {
      :be_present => "%{field} must not be blank",
      :be_unique  => "%{actual} is already taken",
      :be_positive_integer => "%{field} must be a positive number"
    }

    cattr_accessor :specdocs
    # TODO: should or must, which is better?
    # - %{field} should be present
    # - %{field} must be present
    self.specdocs = {
      :be_present => "%{field} should be present",
      :be_unique => "%{field} should be unique",
      :be_positive_integer => "%{field} should be a positive number"
    }

    def self.translate(scope, values={})
      String.new(specdocs[scope]) % values
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


