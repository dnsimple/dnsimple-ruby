require 'spec_helper'

describe DNSimple::Record do

  let(:domain) { DNSimple::Domain.new(:name => 'example.com') }


  describe ".find" do
    before do
      stub_request(:get, %r[/domains/example.com/records/2]).
          to_return(read_fixture("records/show/success.http"))
    end

    it "builds the correct request" do
      described_class.find(domain, "2")

      WebMock.should have_requested(:get, "https://#{CONFIG['username']}:#{CONFIG['password']}@#{CONFIG['host']}/domains/example.com/records/2").
                     with(:headers => { 'Accept' => 'application/json' })
    end

    context "when the record exists" do
      it "returns the record" do
        result = described_class.find(domain, "2")

        expect(result).to be_a(described_class)
        expect(result.id).to eq(1495)
        expect(result.domain).to be(domain)
        expect(result.name).to eq("www")
        expect(result.content).to eq("1.2.3.4")
        expect(result.ttl).to eq(3600)
        expect(result.prio).to be_nil
        expect(result.record_type).to eq("A")
      end
    end
  end


  describe "#fqdn" do
    it "joins the name and domain name" do
      record = described_class.new(:name => 'www', :domain => domain)
      expect(record.fqdn).to eq("www.#{domain.name}")
    end

    it "strips a blank name" do
      record = described_class.new(:name => '', :domain => domain)
      expect(record.fqdn).to eq(domain.name)
    end
  end

end

