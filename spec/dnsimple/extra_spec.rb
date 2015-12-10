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

end
