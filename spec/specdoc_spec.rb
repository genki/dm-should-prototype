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

describe "BePresent" do
  before(:all) { @spec_class = BePresent1.specs[:name].first }

  describe "#doc" do
    subject { @spec_class.doc }

    it "should be \"should be present\"" do
      should == "should be present"
    end
  end

  describe "#scope_to_be_translated, scope" do
    subject { @spec_class.scope }
    it "should be \"be_present\"" do
      should == "be_present"
    end
  end
end


describe "BePositiveInteger" do
  before(:all){ @spec_class = BePositiveInteger1.specs[:number].first }

  describe "#doc" do
    subject { @spec_class.doc }

    it "should be \"should be positive integer\"" do
      should == "should be positive integer"
    end
  end

  describe "#scope_to_be_translated, scope" do
    subject { @spec_class.scope }
    it "should be \"be_positive_integer\"" do
      should == "be_positive_integer"
    end
  end
end


describe "BeUnique" do
  describe "#doc" do

    it "should be \"should be unique\" when no :scope option was given" do
      doc = BeUnique1.specs[:number].first.doc
      doc.should == "should be unique"
    end

    it "should include the list of scopes if any :scope option was given" do
      doc = BeUnique2.specs[:number].first.doc
      doc.should == "should be unique (scope: category)"
    end
  end

  describe "#scope_to_be_translated, scope" do
    subject { BeUnique1.specs[:number].first.scope }
    it "should be \"be_unique\"" do
      should == "be_unique"
    end

    it "how would it be when a record should be unique within particular scopes?" do
      pending "think about this later"
    end
  end
end
