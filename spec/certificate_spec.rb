require 'spec_helper'

describe DNSimple::Certificate do
  let(:domain_name) { 'example.com' }
  let(:domain) { DNSimple::Domain.new(:name => domain_name) }

  describe "#fqdn" do
    it "joins the name and domain name" do
      certificate = DNSimple::Certificate.new(:name => 'www')
      certificate.domain = domain
      certificate.fqdn.should eq("www.#{domain_name}")
    end
    it "strips blank parts from name" do
      certificate = DNSimple::Certificate.new(:name => '')
      certificate.domain = domain
      certificate.fqdn.should eq(domain_name)
    end
  end

  describe ".purchase" do
    let(:contact) { DNSimple::Contact.new(:id => 1) }
    use_vcr_cassette
    it "purchases a certificate" do
      certificate = DNSimple::Certificate.purchase(domain, 'www', contact)
      certificate.fqdn.should eq("www.#{domain_name}")
    end
  end

  describe ".all" do
    use_vcr_cassette
    it "returns all certificates for the specific domain" do
      certificates = DNSimple::Certificate.all(domain)
      certificates.length.should eq(1)
      certificates.first.fqdn.should eq('www.example.com')
    end
  end

  describe "#submit" do
    use_vcr_cassette
    let(:certificate) { DNSimple::Certificate.new(:id => 1) }
    it "submits a certificate for purchase" do
      certificate.submit
    end
  end

end
