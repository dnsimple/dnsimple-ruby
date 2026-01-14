# frozen_string_literal: true

require "test_helper"

describe Dnsimple::Options::Base do
  describe "#initialize" do
    it "accepts a hash" do
      hash = { a: 1 }
      _(Dnsimple::Options::Base.new(hash).to_h).must_equal(hash)
    end

    it "accepts nil" do
      _(Dnsimple::Options::Base.new(nil).to_h).must_equal({})
    end

    it "duplicates given hash" do
      hash = { a: [1] }
      base = Dnsimple::Options::Base.new(hash)
      base.to_h[:a] << 2

      _(base.to_h).must_equal(hash)
    end
  end
end
