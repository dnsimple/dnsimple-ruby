# frozen_string_literal: true

require "test_helper"

describe Dnsimple::Options::ListOptions do
  describe "#to_h" do
    it "returns empty hash if given options equal to nil" do
      options = Dnsimple::Options::ListOptions.new(nil)
      _(options.to_h).must_equal({})
    end

    it "returns empty hash if given options are empty" do
      options = Dnsimple::Options::ListOptions.new({})
      _(options.to_h).must_equal({})
    end

    describe "query" do
      it 'adds "query" key if given options are filled' do
        options = Dnsimple::Options::ListOptions.new(a: 1)
        _(options.to_h).must_include(:query)
      end
    end

    describe "pagination" do
      it 'adds "page" to "query"' do
        raw      = { page: "23" }
        expected = { query: raw }
        options  = Dnsimple::Options::ListOptions.new(raw)

        _(options.to_h).must_equal(expected)
      end

      it 'adds "per_page" to "query"' do
        raw      = { per_page: "500" }
        expected = { query: raw }
        options  = Dnsimple::Options::ListOptions.new(raw)

        _(options.to_h).must_equal(expected)
      end

      it 'combines "page" and "per_page"' do
        raw      = { page: "1", per_page: "100" }
        expected = { query: raw }
        options  = Dnsimple::Options::ListOptions.new(raw)

        _(options.to_h).must_equal(expected)
      end
    end

    describe "sorting" do
      it 'adds sorting policy to "query"' do
        raw      = { sort: "name:desc" }
        expected = { query: raw }
        options  = Dnsimple::Options::ListOptions.new(raw)

        _(options.to_h).must_equal(expected)
      end

      it "combines with filtering" do
        raw      = { sort: "name:desc", filter: { name: "foo" } }
        expected = { query: { sort: raw.fetch(:sort) }.merge(raw.fetch(:filter)) }
        options  = Dnsimple::Options::ListOptions.new(raw)

        _(options.to_h).must_equal(expected)
      end

      it "combines with pagination" do
        raw      = { sort: "name:desc", page: "2", per_page: "100" }
        expected = { query: raw }
        options  = Dnsimple::Options::ListOptions.new(raw)

        _(options.to_h).must_equal(expected)
      end
    end

    describe "filtering" do
      it 'adds filtering policy to "query"' do
        raw      = { filter: { name_like: "example" } }
        expected = { query: raw.fetch(:filter) }
        options  = Dnsimple::Options::ListOptions.new(raw)

        _(options.to_h).must_equal(expected)
      end

      it "combines with sorting" do
        raw      = { filter: { name_like: "bar" }, sort: "tld:desc" }
        expected = { query: raw.fetch(:filter).merge(sort: raw.fetch(:sort)) }
        options  = Dnsimple::Options::ListOptions.new(raw)

        _(options.to_h).must_equal(expected)
      end

      it "combines with pagination" do
        raw      = { filter: { name_like: "example" }, page: "1", per_page: "20" }
        expected = { query: { page: raw.fetch(:page), per_page: raw.fetch(:per_page) }.merge(raw.fetch(:filter)) }
        options  = Dnsimple::Options::ListOptions.new(raw)

        _(options.to_h).must_equal(expected)
      end
    end
  end
end
