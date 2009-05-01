require 'rubygems'

# gem 'dm-core', '0.9.11'
require 'dm-core'

dir = Pathname(__FILE__).dirname.expand_path / 'dm-should'

require dir / "version"
require dir / "spec_collector"
require dir / "spec_collection"
require dir / "spec_classes"
require dir / "before_typecast"
require dir / "translation"
require dir / "errors"
require dir / "model"
require dir / "resource"
