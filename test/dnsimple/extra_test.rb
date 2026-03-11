# frozen_string_literal: true

require "test_helper"

class ExtraTest < Minitest::Test
  test "join uri joins two or more strings" do
    assert_equal "foo", Dnsimple::Extra.join_uri("foo")
    assert_equal "foo/bar", Dnsimple::Extra.join_uri("foo", "bar")
    assert_equal "foo/bar/baz", Dnsimple::Extra.join_uri("foo", "bar", "baz")
  end

  test "join uri removes multiple trailing slashes" do
    assert_equal "foo/bar", Dnsimple::Extra.join_uri("foo", "bar")
    assert_equal "foo/bar", Dnsimple::Extra.join_uri("foo", "bar/")
    assert_equal "foo/bar", Dnsimple::Extra.join_uri("foo/", "bar")
    assert_equal "foo/bar", Dnsimple::Extra.join_uri("foo/", "bar/")
  end

  test "join uri does not strip protocols" do
    assert_equal "https://dnsimple.com/path", Dnsimple::Extra.join_uri("https://dnsimple.com", "path")
  end

  test "validate mandatory attributes raises error if mandatory attribute not present" do
    assert_raises(ArgumentError) do
      Dnsimple::Extra.validate_mandatory_attributes({ name: "foo" }, %i[name email])
    end
  end

  test "validate mandatory attributes does not raise if all attributes present" do
    Dnsimple::Extra.validate_mandatory_attributes({ name: "foo", email: "bar" }, %i[name email])
  end

  test "validate mandatory attributes handles nil as attributes value" do
    assert_raises(ArgumentError) do
      Dnsimple::Extra.validate_mandatory_attributes(nil, %i[name email])
    end
  end
end
