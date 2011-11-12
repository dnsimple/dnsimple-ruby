require 'spec_helper'
require 'dnsimple/commands/submit_certificate'

describe DNSimple::Commands::SubmitCertificate do
  let(:out) { StringIO.new }
  let(:domain) { DNSimple::Domain.new(:name => domain_name) }
  let(:domain_name) { 'example.com' }
  let(:name) { 'www' }
  let(:certificate) { DNSimple::Certificate.new(:id => certificate_id, :domain => domain) }
  let(:certificate_id) { 1 }
  let(:approver_email) { 'admin@example.com' }

  it "submits the certificate" do
    DNSimple::Domain.stubs(:find).with(domain_name).returns(domain)
    DNSimple::Certificate.expects(:find).with(domain, certificate_id).returns(certificate)
    certificate.expects(:submit).with(approver_email)
    DNSimple::Commands::SubmitCertificate.new(out).execute([domain_name, certificate_id, approver_email])
  end
end
