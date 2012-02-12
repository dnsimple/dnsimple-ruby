require 'spec_helper'
require 'dnsimple/commands/list_records'

describe DNSimple::Commands::ListRecords do
  before do
    DNSimple::Record.expects(:all).with(instance_of(DNSimple::Domain)).returns(records)
  end

  let(:records) { [ record ] }
  let(:record) { stub(:ttl => ttl, :id => id, :record_type => record_type, :name => name, :domain => domain, :content => content) }

  let(:ttl) { 'ttl' }
  let(:id) { 'id' }
  let(:record_type) { 'A' }
  let(:name) { 'name' }
  let(:content) { 'content' }

  let(:args) { [ domain_name ] }
  let(:domain_name) { 'example.com' }
  let(:domain) { DNSimple::Domain.new(:name => domain_name) }
  let(:out) { StringIO.new }

  it 'should retrieve all records and print them' do
    described_class.new(out).execute(args)

    out.string.should include(ttl)
    out.string.should include(id)
    out.string.should include(record_type)
    out.string.should include(name)
    out.string.should include(domain_name)
    out.string.should include(content)
  end
end

