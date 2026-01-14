# frozen_string_literal: true

require "test_helper"

class OptionsBaseTest < Minitest::Test

  def test_initialize_accepts_a_hash
    hash = { a: 1 }
    assert_equal hash, Dnsimple::Options::Base.new(hash).to_h
  end

  def test_initialize_accepts_nil
    assert_equal({}, Dnsimple::Options::Base.new(nil).to_h)
  end

  def test_initialize_duplicates_given_hash
    hash = { a: [1] }
    base = Dnsimple::Options::Base.new(hash)
    base.to_h[:a] << 2

    assert_equal hash, base.to_h
  end

end
