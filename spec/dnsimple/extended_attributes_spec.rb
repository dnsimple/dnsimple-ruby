require 'spec_helper'

describe DNSimple::ExtendedAttribute do

  describe "list extended attributes" do
    context "for com" do
      use_vcr_cassette
      it "is an empty array" do
        DNSimple::ExtendedAttribute.find('com').should be_empty
      end
    end

    context "for ca" do
      use_vcr_cassette
      it "is not empty" do
        DNSimple::ExtendedAttribute.find('ca').should_not be_empty
      end
    end
  end

end
