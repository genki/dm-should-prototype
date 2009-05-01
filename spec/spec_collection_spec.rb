require File.dirname(__FILE__) + '/spec_helper'

describe DataMapper::Should::Specs do
  subject { DS::Specs }

  describe "Available subclasses" do
    it "ModelSpecs" do
      should == DS::ModelSpecs.superclass
    end
    it "PropertySpecs" do
      should == DS::PropertySpecs.superclass
    end
    it "Errors" do
      should == DS::Errors.superclass.superclass
    end
  end

  describe "whose Role" do
    # use a PropertySpecs as a example.
    subject { SpecDoc1.specs.on(:number) }


    it "storing SpecClass instances" do
      subject.specs.should be_an(Array)
      subject.specs.each do |spec_class|
        spec_class.should be_a(DS::SpecClass)
      end
    end

    it "providing methods for specdoc generation" do
      subject.specdocs.first.should be_a(String)

      subject.translation_scopes.first.should == "be_present"


      # this method is used in order to delegate another translation system
      # to generate docs. and I think this method should be mainly used.
      # TODO: it's better if the 2nd argument of the proc is a SpecClass
      # instead of assigns as a Hash already constructed.
      # I just prepare SpecClass#assgins to provide default assigns hash.
      
      subject.translation_scopes_each do |translation_scope, assigns|

        # translation scope to pass another translation system
        translation_scope.should be_a(String)

        # assign values for translating
        assigns.should be_a(Hash)
        assigns.should have_key(:field)

      end
    end

  end 
end

describe DataMapper::Should::ModelSpecs do
  subject { SpecDoc2.specs }
  it "should be a subclass of DS::Specs" do
    should be_a(DS::Specs)
  end

  it "whose scope should be a model" do
    subject.scope.should == SpecDoc2
  end

  it "should have specs as a Mash in addition to the specs Array" do
    subject.specs_mash.should be_a(Mash)
  end

  it "should provide specs on a particular property" do
    subject.on(:number).should be_a(DS::PropertySpecs)
  end


  it "should privide specdoc of the model belongs to" do
    # pp subject.specdocs
    subject.specdocs.should be_an(Array)
  end

end

describe DataMapper::Should::PropertySpecs do
  subject { SpecDoc2.specs.on(:number) }

  it "should be a subclass of DS::Specs" do
    should be_a(DS::Specs)
  end

  it "whose scope should be a property" do
    subject.scope.should == SpecDoc2.properties[:number]
  end

  it "should provide specdoc of the property belongs to" do
    # pp subject.specdocs
    subject.specdocs
  end

end


describe DataMapper::Should::Errors do
  subject { SpecDoc1.new.errors }
  it "should be a subclass of DS::ModelSpecs" do
    should be_a(DS::Specs)
    should be_a(DS::ModelSpecs) 
  end

  it "whose scope should be a record" do
    subject.scope.should be_a(DataMapper::Resource)
  end

  it "should privide error message using collected spec classes" do
    SpecDoc2.auto_migrate!
    record = SpecDoc2.new
    record.valid?
    pending
    record.errors.error_messages
  end
end

