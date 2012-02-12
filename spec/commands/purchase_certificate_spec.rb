require 'spec_helper'
require 'dnsimple/certificate'
require 'dnsimple/commands/purchase_certificate'

describe DNSimple::Commands::PurchaseCertificate do
  let(:out) { StringIO.new }
  let(:domain_name) { 'example.com' }
  context "with one argument" do
    xit "purchases the certificate" do
      DNSimple::Certificate.expects(:purchase).with(domain_name, '').returns(stub("certificate", :fqdn => domain_name))
      DNSimple::Commands::PurchaseCertificate.new(out).execute([domain_name])
    end
  end
end
