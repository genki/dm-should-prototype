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

  it "should have a DataMapper::Should::Errors as #errors" do
    @record.errors.should be_a(DataMapper::Should::Errors)
  end

end

describe "Datamapper::Model with dm-should" do

  it "should have a DataMapper::Should::SpecCollection as specs" do
    Item.specs.should be_a(DataMapper::Should::SpecCollection)
    Item.specs.to_a.should have(1).item
    Item.specs[0].should be_a(DataMapper::Should::BePresent)

    Item2.specs.to_a.should have(2).items
    Item2.specs[1].should be_a(DataMapper::Should::BePresent)
  end

end

describe "SpecClasses of DataMapper::Should" do

  it "should has its symbolized name as an attribute" do
    DataMapper::Should::BePresent.name.should == :be_present
  end

  it "could ensure itself of a given resource" do
    item = Item.new
    Item.specs[0].ensure(item)
    item.errors.should_not be_empty 
    item.errors.all? { |spec| spec.satisfy?(item) == false }.should be

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
