require 'spec_helper'
require 'dnsimple/commands/add_service'

describe DNSimple::Commands::AddService do
  let(:out) { StringIO.new }

  let(:domain_name) { 'example.com' }
  let(:short_name) { 'service-name' }
  let(:args) { [domain_name, short_name] }

  let(:domain) { DNSimple::Domain.new(:name => domain_name) }
  let(:service) { stub("service", :name => "Service") }

  before do
    DNSimple::Domain.expects(:find).with(domain_name).returns(domain)
    DNSimple::Service.expects(:find).with(short_name).returns(service)
  end

  it "adds a service to a domain" do
    domain.expects(:add_service).with(short_name)
    DNSimple::Commands::AddService.new(out).execute(args)
  end

  it "reports to the caller" do
    domain.stubs(:add_service)
    DNSimple::Commands::AddService.new(out).execute(args)
    out.string.should eq("Added #{service.name} to #{domain_name}\n")
  end
end
