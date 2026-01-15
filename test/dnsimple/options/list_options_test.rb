# frozen_string_literal: true

require "test_helper"

class ListOptionsTest < Minitest::Test
  test "to h returns empty hash if given options equal to nil" do
    options = Dnsimple::Options::ListOptions.new(nil)

    assert_empty(options.to_h)
  end

  test "to h returns empty hash if given options are empty" do
    options = Dnsimple::Options::ListOptions.new({})

    assert_empty(options.to_h)
  end

  test "to h adds query key if given options are filled" do
    options = Dnsimple::Options::ListOptions.new(a: 1)

    assert_includes options.to_h, :query
  end

  test "pagination adds page to query" do
    raw      = { page: "23" }
    expected = { query: raw }
    options  = Dnsimple::Options::ListOptions.new(raw)

    assert_equal expected, options.to_h
  end

  test "pagination adds per page to query" do
    raw      = { per_page: "500" }
    expected = { query: raw }
    options  = Dnsimple::Options::ListOptions.new(raw)

    assert_equal expected, options.to_h
  end

  test "pagination combines page and per page" do
    raw      = { page: "1", per_page: "100" }
    expected = { query: raw }
    options  = Dnsimple::Options::ListOptions.new(raw)

    assert_equal expected, options.to_h
  end

  test "sorting adds sorting policy to query" do
    raw      = { sort: "name:desc" }
    expected = { query: raw }
    options  = Dnsimple::Options::ListOptions.new(raw)

    assert_equal expected, options.to_h
  end

  test "sorting combines with filtering" do
    raw      = { sort: "name:desc", filter: { name: "foo" } }
    expected = { query: { sort: raw.fetch(:sort) }.merge(raw.fetch(:filter)) }
    options  = Dnsimple::Options::ListOptions.new(raw)

    assert_equal expected, options.to_h
  end

  test "sorting combines with pagination" do
    raw      = { sort: "name:desc", page: "2", per_page: "100" }
    expected = { query: raw }
    options  = Dnsimple::Options::ListOptions.new(raw)

    assert_equal expected, options.to_h
  end

  test "filtering adds filtering policy to query" do
    raw      = { filter: { name_like: "example" } }
    expected = { query: raw.fetch(:filter) }
    options  = Dnsimple::Options::ListOptions.new(raw)

    assert_equal expected, options.to_h
  end

  test "filtering combines with sorting" do
    raw      = { filter: { name_like: "bar" }, sort: "tld:desc" }
    expected = { query: raw.fetch(:filter).merge(sort: raw.fetch(:sort)) }
    options  = Dnsimple::Options::ListOptions.new(raw)

    assert_equal expected, options.to_h
  end

  test "filtering combines with pagination" do
    raw      = { filter: { name_like: "example" }, page: "1", per_page: "20" }
    expected = { query: { page: raw.fetch(:page), per_page: raw.fetch(:per_page) }.merge(raw.fetch(:filter)) }
    options  = Dnsimple::Options::ListOptions.new(raw)

    assert_equal expected, options.to_h
  end
end
