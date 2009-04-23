require File.dirname(__FILE__) + '/spec_helper'

class SpecDoc1
  include DataMapper::Resource

  property :id, Serial
  property_with_spec :number, String do
    should be_present
    should be_unique
    should be_positive_integer
  end

end

describe "DataMapper::Should provides model.specdoc system" do

  before(:all) do
    SpecDoc1.auto_migrate!
  end
  
  it "should generate specdoc" do 
    specdoc = SpecDoc1.specdoc
    specdoc.should include("number:")
    specdoc.should include("- should be present")
    specdoc.should include("- should be unique")
    specdoc.should include("- should be positive integer")
  end


  it "could generate translated specdoc" do
    pending "implement later"
  end

end
