require File.dirname(__FILE__) + '/spec_helper'

describe "DataMapper::Should provides model.specdoc system" do

  before(:all) do
    SpecDoc1.auto_migrate!
  end
  
  it "should generate specdoc" do 
    specdoc = SpecDoc1.specdoc
    specdoc.should include("number:")
    specdoc.should include("- should be present")
    specdoc.should include("- should be unique")
    specdoc.should include("- should be a positive number")
  end

end

describe "BePresent" do
  before(:all) { @spec_class = BePresent1.specs[:name].first }

  describe "#doc" do
    subject { @spec_class.doc }

    it "should be \"BePresent1.name should be present\"" do
      should == "BePresent1.name should be present"
    end
  end

  describe "#translation_scope, scope" do
    subject { @spec_class.translation_scope }
    it "should include \"be_present\"" do
      should == "BePresent1.name.be_present"
    end
  end
end


describe "BePositiveInteger" do
  before(:all){ @spec_class = BePositiveInteger1.specs[:number].first }

  describe "#doc" do
    subject { @spec_class.doc }

    it "should be \"BePositiveInteger1.number should be a positive number\"" do
      should == "BePositiveInteger1.number should be a positive number"
    end
  end

  describe "#translation_scope, scope" do
    subject { @spec_class.translation_scope }
    it "should include \"be_positive_integer\"" do
      should == "BePositiveInteger1.number.be_positive_integer"
    end
  end
end


describe "BeUnique" do
  describe "#doc" do

    it "should be \"BeUnique1.number should be unique\" when no :scope option was given" do
      doc = BeUnique1.specs[:number].first.doc
      doc.should == "BeUnique1.number should be unique"
    end

    it "should include the list of scopes if any :scope option was given" do
      doc = BeUnique2.specs[:number].first.doc
      doc.should == "BeUnique2.number should be unique (scope: category)"
    end
  end

  describe "#translation_scope, scope" do
    it "should include \"be_unique\"" do
      scope = BeUnique1.specs[:number].first.translation_scope
      scope.should include("be_unique")
    end

    it "should include \"be_unique_within_scopes\" when a record should be unique within particular scopes?" do
      scope = BeUnique2.specs[:number].first.translation_scope
      scope.should include("be_unique_within_scopes")
    end
  end
end
