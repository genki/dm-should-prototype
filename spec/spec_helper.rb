require 'pathname'
require 'rubygems'

# gem 'dm-core', '0.9.11'
require 'dm-core'

ROOT = Pathname(__FILE__).dirname.parent.expand_path

require ROOT + 'lib/dm-should'

DataMapper.setup(:default, 'sqlite3::memory:')
