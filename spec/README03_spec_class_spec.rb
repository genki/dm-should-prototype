require File.dirname(__FILE__) + '/spec_helper'
require File.dirname(__FILE__) + '/rdoc_helper'

h3 "03: Spec Class of dm-should" do

  h4 "What is SpecClass?
For example, when you have an Item class like this:
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
   
    it "<tt>Item.specs.on(:name).to_a</tt> is an array of SpecClass's.

  Strictly speaking, they're <tt>DataMapper::Should::BePresent</tt>, 
  <tt>DataMapper::Should::BeUnique</tt> and <tt>DataMapper::Should::Match</tt>,

  and <tt>Item.specs.on(:name)</tt> is a <tt>DataMapper::Should::PropertySpecs</tt>'s instance.
  " do
      Item3.specs.on(:name).each do |klass|
        klass.should be_a(DS::SpecClass)
      end

      Item3.specs.on(:name)[0].should be_a(DS::BePresent)
      Item3.specs.on(:name)[1].should be_a(DS::BeUnique)
      Item3.specs.on(:name)[2].should be_a(DS::Match)

      Item.specs.on(:name).should be_an_instance_of(DS::PropertySpecs)

    end


    it "And <tt>record.errors.on(:name).to_a</tt> is also an array of SpecClass's.
    
  <tt>record.errors.on(:name)</tt> is a <tt>DataMapper::Should::ErrorsOnProperty</tt>'s instance.
    " do
      Item3.auto_migrate!
      record = Item3.new
      record.valid?.should be_false

      record.errors.on(:name).each do |klass|
        klass.should be_a(DS::SpecClass)
      end

      record.errors.on(:name).should be_an_instance_of(DS::ErrorsOnProperty)

    end

  end

end

h4 "Each Spec Class is responsible for validation" do
  it "They have <tt>satisfy?</tt> method to ensure themselves

  <tt>satisfy?</tt> method is sended when <tt>record.valid?</tt> .   
  " do 
    record = Item3.new
    spec = Item3.specs.on(:name)[0]
    spec.should be_a(DS::BePresent)
    spec.satisfy?(record).should be_false
    
    record.name = "present"
    spec.satisfy?(record).should be_true
  end
end

