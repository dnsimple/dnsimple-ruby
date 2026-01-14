# frozen_string_literal: true

require "test_helper"

class ListOptionsTest < Minitest::Test
  def test_to_h_returns_empty_hash_if_given_options_equal_to_nil
    options = Dnsimple::Options::ListOptions.new(nil)

    assert_empty(options.to_h)
  end

  def test_to_h_returns_empty_hash_if_given_options_are_empty
    options = Dnsimple::Options::ListOptions.new({})

    assert_empty(options.to_h)
  end

  def test_to_h_adds_query_key_if_given_options_are_filled
    options = Dnsimple::Options::ListOptions.new(a: 1)

    assert_includes options.to_h, :query
  end

  def test_pagination_adds_page_to_query
    raw      = { page: "23" }
    expected = { query: raw }
    options  = Dnsimple::Options::ListOptions.new(raw)

    assert_equal expected, options.to_h
  end

  def test_pagination_adds_per_page_to_query
    raw      = { per_page: "500" }
    expected = { query: raw }
    options  = Dnsimple::Options::ListOptions.new(raw)

    assert_equal expected, options.to_h
  end

  def test_pagination_combines_page_and_per_page
    raw      = { page: "1", per_page: "100" }
    expected = { query: raw }
    options  = Dnsimple::Options::ListOptions.new(raw)

    assert_equal expected, options.to_h
  end

  def test_sorting_adds_sorting_policy_to_query
    raw      = { sort: "name:desc" }
    expected = { query: raw }
    options  = Dnsimple::Options::ListOptions.new(raw)

    assert_equal expected, options.to_h
  end

  def test_sorting_combines_with_filtering
    raw      = { sort: "name:desc", filter: { name: "foo" } }
    expected = { query: { sort: raw.fetch(:sort) }.merge(raw.fetch(:filter)) }
    options  = Dnsimple::Options::ListOptions.new(raw)

    assert_equal expected, options.to_h
  end

  def test_sorting_combines_with_pagination
    raw      = { sort: "name:desc", page: "2", per_page: "100" }
    expected = { query: raw }
    options  = Dnsimple::Options::ListOptions.new(raw)

    assert_equal expected, options.to_h
  end

  def test_filtering_adds_filtering_policy_to_query
    raw      = { filter: { name_like: "example" } }
    expected = { query: raw.fetch(:filter) }
    options  = Dnsimple::Options::ListOptions.new(raw)

    assert_equal expected, options.to_h
  end

  def test_filtering_combines_with_sorting
    raw      = { filter: { name_like: "bar" }, sort: "tld:desc" }
    expected = { query: raw.fetch(:filter).merge(sort: raw.fetch(:sort)) }
    options  = Dnsimple::Options::ListOptions.new(raw)

    assert_equal expected, options.to_h
  end

  def test_filtering_combines_with_pagination
    raw      = { filter: { name_like: "example" }, page: "1", per_page: "20" }
    expected = { query: { page: raw.fetch(:page), per_page: raw.fetch(:per_page) }.merge(raw.fetch(:filter)) }
    options  = Dnsimple::Options::ListOptions.new(raw)

    assert_equal expected, options.to_h
  end
end
