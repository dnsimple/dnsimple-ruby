# frozen_string_literal: true

require "test_helper"

class OptionsBaseTest < Minitest::Test
  test "initialize accepts a hash" do
    hash = { a: 1 }

    assert_equal hash, Dnsimple::Options::Base.new(hash).to_h
  end

  test "initialize accepts nil" do
    assert_empty(Dnsimple::Options::Base.new(nil).to_h)
  end

  test "initialize duplicates given hash" do
    hash = { a: [1] }
    base = Dnsimple::Options::Base.new(hash)
    base.to_h[:a] << 2

    assert_equal hash, base.to_h
  end
end
