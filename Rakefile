require 'pathname'
require 'rubygems'

ROOT    = Pathname(__FILE__).dirname.expand_path
JRUBY   = RUBY_PLATFORM =~ /java/
WINDOWS = Gem.win_platform?
SUDO    = (WINDOWS || JRUBY) ? '' : ('sudo' unless ENV['SUDOLESS'])

require ROOT + 'lib/dm-should/version'

AUTHOR = 'Yukiko kawamoto'
EMAIL  = 'yu0420 [a] gmail [d] com'
GEM_NAME = 'dm-should'
GEM_VERSION = DataMapper::Should::VERSION
GEM_DEPENDENCIES = [['dm-core', GEM_VERSION]]
GEM_CLEAN = %w[ log pkg coverage ]
GEM_EXTRAS = { :has_rdoc => true, :extra_rdoc_files => %w[ README.rdoc LICENSE] }

PROJECT_NAME = GEM_NAME
PROJECT_URL  = "http://github.com/yukiko/#{GEM_NAME}"
PROJECT_DESCRIPTION = PROJECT_SUMMARY = 'DataMapper plugin for propeties with specifications'

[ ROOT, ROOT.parent ].each do |dir|
  Pathname.glob(dir.join('tasks/**/*.rb').to_s).each { |f| require f }
end
