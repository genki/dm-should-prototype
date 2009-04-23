require File.join(File.dirname(__FILE__) , %w[.. /spec_helper])

class BeUnique1
  include DataMapper::Resource

  property :id, Serial
  property_with_spec :number, Integer do
    should be_unique
  end

end

class BeUnique2
  include DataMapper::Resource
  
  property :id, Serial
  property :category, String
  property_with_spec :number, Integer do
    should be_unique(:scope => :category)
  end

end


describe "when a [Integer] record.number should be unique, record.valid? returns .." do
  before do
    @model1 = BeUnique1
    BeUnique1.auto_migrate!
    @model2 = BeUnique2
    BeUnique2.auto_migrate!
  end
  attr_reader :model1, :model2
  

  it "true  if it is unique [when create]" do
    record = model1.new(:number => 100)
    record.valid?.should be_true
  end


  it "false if it isn't unique" do
    model1.create(:number => 100)

    record = model1.new(:number => 100)
    record.valid?.should be_false

    record = model1.new(:number => 200)
    record.valid?.should be_true
  end


  # When Update
  it "true  if it is unique [when update]" do
    created = model1.create(:number => 100)
    created.valid?.should be_true
  end


  # With :scope option
  it "true  if it is unique within some scopes" do
    model2.create(:number => 100, :category => :cat)

    record = model2.new(:number => 100, :category => :dog)
    record.valid?.should be_true
  end

  it "false if it is also not unique within some scopes" do
    model2.create(:number => 100, :category => :cat)

    record = model2.new(:number => 100, :category => :cat)
    record.valid?.should be_false
  end

end



describe "BeUnique#doc" do

  it "should be \"should be unique\" when no :scope option was given" do
    doc = BeUnique1.specs[:number].first.doc
    doc.should == "should be unique"
  end

  it "should include the list of scopes if any :scope option was given" do
    doc = BeUnique2.specs[:number].first.doc
    doc.should == "should be unique (scope: category)"
  end

end
