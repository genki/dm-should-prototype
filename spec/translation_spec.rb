require File.dirname(__FILE__) + '/spec_helper'

describe DataMapper::Should::Translation do
  
  describe ".raw" do 
    it "should returns sentence not yet translated" do
      raw = DataMapper::Should::Translation.raw("warn.be_present")
      raw.should be_a(String)
      raw.should include("%{field}")
      raw.should include("%{actual}")
    end
  end

  describe ".translate" do

    it "should defalt prefix to scope if needed" do
      full = DataMapper::Should::Translation.translate("specdoc.be_present")
      DataMapper::Should::Translation.translate("be_present").should == full
    end

  end

end
