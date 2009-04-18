require File.dirname(__FILE__) + '/spec_helper'

class Item
  include DataMapper::Resource 

  property :id, Serial
  property_with_spec :name, String do
    should.be_present
  end

end

describe "DataMapper::Resource with dm-should" do
  it "could check presence of attributes" do

    record = Item.new

    # When record.name is nil
    record.valid?.should == false

    # When record.name is empty string.
    record.name = ""
    record.valid?.should == false

    # When record.name is string which is not empty.
    reocrd.name = "foo"
    record.valid?.should == true

  end
end
