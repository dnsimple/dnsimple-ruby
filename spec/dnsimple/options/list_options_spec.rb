# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Dnsimple::Options::ListOptions do
  describe '#to_h' do
    it 'returns empty hash if given options equal to nil' do
      options = described_class.new(nil)
      expect(options.to_h).to eq({})
    end

    it 'returns empty hash if given options are empty' do
      options = described_class.new({})
      expect(options.to_h).to eq({})
    end

    context 'query' do
      it 'adds "query" key if given options are filled' do
        options = described_class.new(a: 1)
        expect(options.to_h).to have_key(:query)
      end
    end

    context 'pagination' do
      it 'adds "page" to "query"' do
        raw      = { page: '23' }
        expected = { query: raw }
        options  = described_class.new(raw)

        expect(options.to_h).to eq(expected)
      end

      it 'adds "per_page" to "query"' do
        raw      = { per_page: '500' }
        expected = { query: raw }
        options  = described_class.new(raw)

        expect(options.to_h).to eq(expected)
      end

      it 'combines "page" and "per_page"' do
        raw      = { page: '1', per_page: '100' }
        expected = { query: raw }
        options  = described_class.new(raw)

        expect(options.to_h).to eq(expected)
      end
    end

    context 'sorting' do
      it 'adds sorting policy to "query"' do
        raw      = { sort: 'name:desc' }
        expected = { query: raw }
        options  = described_class.new(raw)

        expect(options.to_h).to eq(expected)
      end

      it 'combines with filtering' do
        raw      = { sort: 'name:desc', filter: { name: 'foo' } }
        expected = { query: { sort: raw.fetch(:sort) }.merge(raw.fetch(:filter)) }
        options  = described_class.new(raw)

        expect(options.to_h).to eq(expected)
      end

      it 'combines with pagination' do
        raw      = { sort: 'name:desc', page: '2', per_page: '100' }
        expected = { query: raw }
        options  = described_class.new(raw)

        expect(options.to_h).to eq(expected)
      end
    end

    context 'filtering' do
      it 'adds filtering policy to "query"' do
        raw      = { filter: { name_like: 'example' } }
        expected = { query: raw.fetch(:filter) }
        options  = described_class.new(raw)

        expect(options.to_h).to eq(expected)
      end

      it 'combines with sorting' do
        raw      = { filter: { name_like: 'bar' }, sort: 'tld:desc' }
        expected = { query: raw.fetch(:filter).merge(sort: raw.fetch(:sort)) }
        options  = described_class.new(raw)

        expect(options.to_h).to eq(expected)
      end

      it 'combines with pagination' do
        raw      = { filter: { name_like: 'example' }, page: '1', per_page: '20' }
        expected = { query: { page: raw.fetch(:page), per_page: raw.fetch(:per_page) }.merge(raw.fetch(:filter)) }
        options  = described_class.new(raw)

        expect(options.to_h).to eq(expected)
      end
    end
  end
end
