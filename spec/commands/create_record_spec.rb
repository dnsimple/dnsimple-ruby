require 'spec_helper'
require 'dnsimple/domain'
require 'dnsimple/record'
require 'dnsimple/commands/create_record'

describe DNSimple::Commands::CreateRecord do
  let(:out) { StringIO.new }
  let(:domain_name) { 'example.com' }
  let(:record_name) { 'www' }
  let(:record_type) { 'CNAME' }
  let(:ttl) { "3600" }
  context "with one argument" do
    it "purchases the certificate" do
      domain_stub = stub("domain", :name => domain_name)
      record_stub = stub("record", :id => 1, :record_type => record_type)
      DNSimple::Domain.expects(:find).with(domain_name).returns(domain_stub)
      DNSimple::Record.expects(:create).with(domain_stub, record_name, record_type, domain_name, :ttl => ttl, :prio => nil).returns(record_stub)

      DNSimple::Commands::CreateRecord.new(out).execute([domain_name, record_name, record_type, domain_name, ttl])
    end
  end
end

