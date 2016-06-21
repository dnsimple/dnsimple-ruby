require 'spec_helper'

RSpec.describe Dnsimple::Options::Base do
  describe '#initialize' do
    it 'accepts a hash' do
      hash = { a: 1 }
      expect(described_class.new(hash).to_h).to eq(hash)
    end

    it 'accepts nil' do
      expect(described_class.new(nil).to_h).to eq({})
    end

    it 'duplicates given hash' do
      hash = { a: [1] }
      base = described_class.new(hash)
      base.to_h[:a] << 2

      expect(base.to_h).to eq(hash)
    end
  end
end
