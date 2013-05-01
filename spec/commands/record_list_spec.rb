require 'spec_helper'
require 'dnsimple/commands/record_list'

describe DNSimple::Commands::RecordList do
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

end

