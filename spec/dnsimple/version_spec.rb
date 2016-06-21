require 'spec_helper'

RSpec.describe Dnsimple::VERSION do

  it 'returns current version' do
    expect(subject).to eq('3.1.0')
  end

end
