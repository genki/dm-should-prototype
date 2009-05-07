require File.dirname(__FILE__) + '/spec_helper'
require File.dirname(__FILE__) + '/rdoc_helper'

h3 "Spec Class of dm-should" do

  h4 "What is SpecClass? For example ..
If you have an Item class like this:
  class Item
    include DataMapper::Resource
    property :id, Serial
    property_with_spec :name, String do
      should be_present
      should be_unique
      should match(/^A/)
    end
  end
  " do  

    before :all do
  class Item3
    include DataMapper::Resource
    property :id, Serial
    property_with_spec :name, String do
      should be_present
      should be_unique
      should match(/^A/)
    end
  end
    end
   
    it "Item.specs.on(:name) is an array of SpecClass's.

  Strictly speaking, they're <tt>DataMapper::Should::BePresent</tt>, 
  <tt>DataMapper::Should::BeUnique</tt> and <tt>DataMapper::Should::Match</tt>.
  " do
      Item3.specs.on(:name).each do |klass|
        klass.should be_a(DS::SpecClass)
      end

      Item3.specs.on(:name)[0].should be_a(DS::BePresent)
      Item3.specs.on(:name)[1].should be_a(DS::BeUnique)
      Item3.specs.on(:name)[2].should be_a(DS::Match)

    end


    it "And record.errors.on(:name) is also an array of SpecClass's." do
      Item3.auto_migrate!
      record = Item3.new
      record.valid?.should be_false

      record.errors.on(:name).each do |klass|
        klass.should be_a(DS::SpecClass)
      end

    end

    
  end


end

