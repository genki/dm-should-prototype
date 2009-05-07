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
   
    it "<tt>Item.specs.on(:name)</tt> is an array of SpecClass's.

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


    it "And <tt>record.errors.on(:name)</tt> is also an array of SpecClass's." do
      Item3.auto_migrate!
      record = Item3.new
      record.valid?.should be_false

      record.errors.on(:name).each do |klass|
        klass.should be_a(DS::SpecClass)
      end

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

