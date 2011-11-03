require 'spec_helper'

describe DNSimple::Certificate do
  let(:domain) { DNSimple::Domain.new(:name => 'example.com') }
  describe "#fqdn" do
    it "joins the name and domain name" do
      certificate = DNSimple::Certificate.new(:name => 'www')
      certificate.domain = domain
      certificate.fqdn.should eq('www.example.com')
    end
    it "strips blank parts from name" do
      certificate = DNSimple::Certificate.new(:name => '')
      certificate.domain = domain
      certificate.fqdn.should eq('example.com')
    end
  end

end
