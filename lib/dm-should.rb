require 'rubygems'

# gem 'dm-core', '0.9.11'
require 'dm-core'

dir = Pathname(__FILE__).dirname.expand_path / 'dm-should'

require dir / "version"
require dir / "spec_collector"
require dir / "spec_class"
%w[be_present be_integer be_unique].each do |file|
  require dir / "spec_class" / file
end
require dir / "translation"
require dir / "specs"
%w[property_specs model_specs errors].each do |file|
  require dir / "specs" / file
end
require dir / "before_typecast"
require dir / "model"
require dir / "resource"
