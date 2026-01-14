# frozen_string_literal: true

require "test_helper"

describe Dnsimple::Extra do

  describe ".join_uri" do
    it "joins two or more strings" do
      _(Dnsimple::Extra.join_uri("foo")).must_equal("foo")
      _(Dnsimple::Extra.join_uri("foo", "bar")).must_equal("foo/bar")
      _(Dnsimple::Extra.join_uri("foo", "bar", "baz")).must_equal("foo/bar/baz")
    end

    it "removes multiple trailing /" do
      _(Dnsimple::Extra.join_uri("foo", "bar")).must_equal("foo/bar")
      _(Dnsimple::Extra.join_uri("foo", "bar/")).must_equal("foo/bar")
      _(Dnsimple::Extra.join_uri("foo/", "bar")).must_equal("foo/bar")
      _(Dnsimple::Extra.join_uri("foo/", "bar/")).must_equal("foo/bar")
    end

    it "does not strip protocols" do
      _(Dnsimple::Extra.join_uri("https://dnsimple.com", "path")).must_equal("https://dnsimple.com/path")
    end
  end

  describe ".validate_mandatory_attributes" do
    let(:mandatory_attributes) { %i[name email] }

    it "raises an error if a mandatory attribute is not present" do
      _ {
        Dnsimple::Extra.validate_mandatory_attributes({ name: "foo" }, mandatory_attributes)
      }.must_raise(ArgumentError)
    end

    it "does not raise an error if all attributes are present" do
      Dnsimple::Extra.validate_mandatory_attributes({ name: "foo", email: "bar" }, mandatory_attributes)
    end

    it "handles nil as attributes value" do
      _ {
        Dnsimple::Extra.validate_mandatory_attributes(nil, mandatory_attributes)
      }.must_raise(ArgumentError)
    end
  end

end
