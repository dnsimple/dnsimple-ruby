require 'spec_helper'

describe Dnsimple::Extra do

  describe ".join_uri" do
    it "joins two or more strings" do
      expect(described_class.join_uri("foo")).to eq("foo")
      expect(described_class.join_uri("foo", "bar")).to eq("foo/bar")
      expect(described_class.join_uri("foo", "bar", "baz")).to eq("foo/bar/baz")
    end

    it "removes multiple trailing /" do
      expect(described_class.join_uri("foo", "bar")).to eq("foo/bar")
      expect(described_class.join_uri("foo", "bar/")).to eq("foo/bar")
      expect(described_class.join_uri("foo/", "bar")).to eq("foo/bar")
      expect(described_class.join_uri("foo/", "bar/")).to eq("foo/bar")
    end

    it "does not strip protocols" do
      expect(described_class.join_uri("https://dnsimple.com", "path")).to eq("https://dnsimple.com/path")
    end
  end

  describe ".validate_mandatory_attributes" do
    let(:mandatory_attributes) { %i{name email} }

    it "raises an error if a mandatory attribute is not present " do
      expect {
        described_class.validate_mandatory_attributes({ name: "foo" }, mandatory_attributes)
      }.to raise_error(ArgumentError, ":email is required")
    end

    it "does not raise an error if all attributes are present" do
      expect {
        described_class.validate_mandatory_attributes({ name: "foo", email: "bar" }, mandatory_attributes)
      }.not_to raise_error
    end

    it "handles nil as attributes value" do
      expect {
        described_class.validate_mandatory_attributes(nil, mandatory_attributes)
      }.to raise_error(ArgumentError, ":name is required")
    end
  end

end
