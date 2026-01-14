# frozen_string_literal: true

require "test_helper"

class ExtraTest < Minitest::Test
  def test_join_uri_joins_two_or_more_strings
    assert_equal "foo", Dnsimple::Extra.join_uri("foo")
    assert_equal "foo/bar", Dnsimple::Extra.join_uri("foo", "bar")
    assert_equal "foo/bar/baz", Dnsimple::Extra.join_uri("foo", "bar", "baz")
  end

  def test_join_uri_removes_multiple_trailing_slashes
    assert_equal "foo/bar", Dnsimple::Extra.join_uri("foo", "bar")
    assert_equal "foo/bar", Dnsimple::Extra.join_uri("foo", "bar/")
    assert_equal "foo/bar", Dnsimple::Extra.join_uri("foo/", "bar")
    assert_equal "foo/bar", Dnsimple::Extra.join_uri("foo/", "bar/")
  end

  def test_join_uri_does_not_strip_protocols
    assert_equal "https://dnsimple.com/path", Dnsimple::Extra.join_uri("https://dnsimple.com", "path")
  end

  def test_validate_mandatory_attributes_raises_error_if_mandatory_attribute_not_present
    assert_raises(ArgumentError) do
      Dnsimple::Extra.validate_mandatory_attributes({ name: "foo" }, %i[name email])
    end
  end

  def test_validate_mandatory_attributes_does_not_raise_if_all_attributes_present
    Dnsimple::Extra.validate_mandatory_attributes({ name: "foo", email: "bar" }, %i[name email])
  end

  def test_validate_mandatory_attributes_handles_nil_as_attributes_value
    assert_raises(ArgumentError) do
      Dnsimple::Extra.validate_mandatory_attributes(nil, %i[name email])
    end
  end
end
