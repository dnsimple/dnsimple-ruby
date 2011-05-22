require File.join(File.dirname(__FILE__), 'spec_helper')

describe DNSimple::ExtendedAttribute do

  describe "list extended attributes" do
    context "for com" do
      it "is an empty array" do
        DNSimple::ExtendedAttribute.find('com').should be_empty
      end
    end
    context "for ca" do
      it "is not empty" do
        DNSimple::ExtendedAttribute.find('ca').should_not be_empty
      end
    end
  end
end
