require File.dirname(__FILE__) + '/spec_helper'

describe DataMapper::Should::Translation do
  
  describe ".raw" do 
    it "should returns sentence not yet translated" do
      raw = DataMapper::Should::Translation.raw(:warn_like_rspec, :be_present)
      it_should_be_raw_message raw
    end

    it "should accept the same set of arguments as translate method" do
      raw = DataMapper::Should::Translation.raw(:warn_like_rspec, :be_present, 
        {:field => "fieldname", :actual => "actualvalue"})
      it_should_be_raw_message raw
    end

    def it_should_be_raw_message(raw)
      raw.should be_a(String)
      raw.should include("%{field}")
      raw.should include("%{actual}")
    end

  end

  it "should have a default doctype" do
    raw = DataMapper::Should::Translation.raw(:be_present)
    raw.should == "%{field} should be present"
  end

end
