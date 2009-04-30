require File.dirname(__FILE__) + '/spec_helper'

describe "DataMappere::Should::Specs" do
  before do
    @model = SpecDoc1
  end
  subject { @model.specs }

  describe "#scope" do
    before do
      @model_specs = Item2.specs
      @property_specs = @model_specs.on(:name)
    end

    it "ModelSpecs#scope should be a model" do 
      @model_specs.should be_instance_of(DataMapper::Should::ModelSpecs)
      @model_specs.scope.should be_a(DataMapper::Model)
    end

    it "PropertySpecs#scope should be a property" do
      @property_specs.should be_instance_of(DataMapper::Should::PropertySpecs)
      @property_specs.property.should be_a(DataMapper::Property)
    end
  end

  describe "has spec classes, and each spec class belongs to one of its model.properties" do

    it "#specs is an array of spec classes" do
      subject.specs.should be_an(Array)  
      subject.specs.each do |spec_class|
        spec_class.should be_a(DataMapper::Should::SpecClass)
      end
    end

    it "#specs_mash is a Mash" do
      subject.specs_mash.should be_a(Mash)
      subject.specs_mash[:number].should be_an(DataMapper::Should::Specs)
      subject.specs_mash[:number][0].should be_a(DataMapper::Should::SpecClass)
    end

  end

  describe "#[] and #on" do
    it "should access @specs array if given argument is Fixnum" do
      subject[0].should == subject.specs[0]
    end

    it "should access @specs_mash if given arugment is String, Symbol, or DataMapper::Property" do
      subject.on(:number).should == subject.specs_mash[:number]

      property = @model.properties[:number]
      subject.on(property).should == subject.specs_mash[property.name]

    end
  end

  
end
