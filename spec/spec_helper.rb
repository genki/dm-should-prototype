require 'pathname'
require "pp"
require 'rubygems'

# gem 'dm-core', '0.9.11'
require 'dm-core'
require 'dm-aggregates'

ROOT = Pathname(__FILE__).dirname.parent.expand_path

require ROOT + 'lib/dm-should'
require ROOT + 'spec/fixture/models'

DataMapper.setup(:default, 'sqlite3::memory:')
