require 'spec_helper'
require 'dnsimple/certificate'
require 'dnsimple/commands/purchase_certificate'

describe DNSimple::Commands::PurchaseCertificate do
  
  let(:out) { StringIO.new }
  let(:domain_name) { 'example.com' }
  let(:domain) { DNSimple::Domain.new(:name => domain_name) }
  let(:contact_id) { 123 }
  let(:contact) { DNSimple::Contact.new(:first_name => 'John', :last_name => 'Doe') }
  let(:name) { "John Doe" }
  
  context "with one argument" do
    it "purchases the certificate" do
      
      DNSimple::Domain.expects(:find).with(domain_name).returns(domain)
      DNSimple::Contact.expects(:find).with(contact_id).returns(contact)
      DNSimple::Certificate.expects(:purchase).with(domain, name, contact).returns(stub("certificate", :fqdn => domain_name))
      
      DNSimple::Commands::PurchaseCertificate.new(out).execute([domain_name, name, contact_id])
    end
  end
end
