require File.dirname(__FILE__) + '/spec_helper'

describe "DataMapper::Should::Errors as a record.errors" do 

  describe "record.errors.error_messages" do
    it "returns an array of generated messages"
  end

  describe "record.errors.error_message_scopes" do
    it "returns an array of translation scopes for error message" do
      SpecDoc2.auto_migrate!
      record = SpecDoc2.new
      record.number = 100
      record.number2 = 100
      record.save

      record = SpecDoc2.new
      record.number2 = 100
      record.valid?.should be_false

      [ "warn.SpecDoc2.number.be_present",
        "warn.SpecDoc2.number.be_positive_integer", 
        "warn.SpecDoc2.number2.be_unique" ].each do |scope| 
        
        record.errors.error_message_scopes.should include(scope)

      end

    end
  end
  
end

