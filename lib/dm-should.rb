require 'rubygems'

# gem 'dm-core', '0.9.11'
require 'dm-core'

dir = Pathname(__FILE__).dirname.expand_path / 'dm-should'

module DataMapper
  module Model
    
    def property_with_spec(*args, &block)
      property(*args)
    end

  end
end

module DataMapper
  module Resource

    def valid?
      true
    end

  end
end
