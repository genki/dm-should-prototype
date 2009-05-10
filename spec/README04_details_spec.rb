require File.dirname(__FILE__) + '/spec_helper'
require File.dirname(__FILE__) + '/rdoc_helper'

h3 "04: Details, especially about each SpecClass's" do

  it "TODO: I'll put some infomation here" do
    true.should be_true
  end
  
end

spec_class_dir = File.join(File.dirname(__FILE__), "spec_classes")
%[be_present].each do |file|
  require File.join(spec_class_dir, file)
end
