require File.dirname(__FILE__) + '/spec_helper'

class Item
  include DataMapper::Resource 

  property :id, Serial
  property_with_spec :name, String do
    should be_present
  end

  ensure_spec

end

describe "DataMapper::Resource with dm-should" do

  subject do
    @record
  end

  before do
    @record = Item.new
  end


  it "should respond_to :ensure_specs" do
    should respond_to(:ensure_specs)
  end


  it "should have specs as a class attribute" do
    Item.specs.should be_a(DataMapper::Should::SpecCollection)
    Item.specs.to_ary.should have(1).item
    Item.specs.to_ary.first.should be_a(DataMapper::Should::BePresent)
  end


  it "could check presence of attributes" do
    pending "the 1st goal"

    # When record.name is nil
    @record.valid?.should == false

    # When @record.name is empty string.
    @record.name = ""
    @record.valid?.should == false

    # When @record.name is string which is not empty.
    reocrd.name = "foo"
    @record.valid?.should == true

  end

end

describe "Spec Classes of DataMapper::Should" do

  it "should has its symbolized name as an attribute" do
    DataMapper::Should::BePresent.name.should == :be_present
  end

end
