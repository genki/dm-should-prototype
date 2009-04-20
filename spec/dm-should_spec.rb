require File.dirname(__FILE__) + '/spec_helper'

class Item
  include DataMapper::Resource 

  property :id, Serial
  property_with_spec :name, String do
    should be_present
  end

end

class Item2
  include DataMapper::Resource 

  property :id, Serial
  property_with_spec :name, String do
    should be_present
  end
  property_with_spec :price, Integer do
    should be_present
  end

end

describe "DataMapper::Resource with dm-should" do

  subject do
    @record
  end

  before do
    @record = Item.new
  end


  it "should respond_to #ensure_specs" do
    should respond_to(:ensure_specs)
  end

  it "#ensure_specs should executed when #valid?" do
    @record.should_receive(:ensure_specs)
    @record.valid?
  end


  it "should have specs as a class attribute" do
    Item.specs.should be_a(DataMapper::Should::SpecCollection)
    Item.specs.to_a.should have(1).item
    Item.specs[0].should be_a(DataMapper::Should::BePresent)

    Item2.specs.to_a.should have(2).items
    Item2.specs[1].should be_a(DataMapper::Should::BePresent)
  end


  it "could check presence of attributes" do

    # When record.name is nil
    @record.valid?.should == false

    # When @record.name is empty string.
    @record.name = ""
    @record.valid?.should == false

    # When @record.name is string which is not empty.
    @record.name = "foo"
    @record.valid?.should == true

  end

end

describe "Spec Classes of DataMapper::Should" do

  it "should has its symbolized name as an attribute" do
    DataMapper::Should::BePresent.name.should == :be_present
  end

  it "could ensure itself of a given resource" do
    item = Item.new
    Item.specs[0].ensure(item)
    item.errors.should_not be_empty 


    item = Item.new
    item.name = "satisfy"
    Item.specs[0].ensure(item)
    item.errors.should be_empty

    item = Item2.new
    item.name = "satisfy"
    Item2.specs[0].ensure(item)
    item.errors.should be_empty
    Item2.specs[1].ensure(item)
    item.errors.should_not be_empty 
  end

end
