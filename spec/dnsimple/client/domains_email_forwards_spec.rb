require 'spec_helper'

describe Dnsimple::Client, ".domains" do

  subject { described_class.new(base_url: "https://api.dnsimple.test", access_token: "a1b2c3").domains }


  describe "#email_forwards" do
    let(:account_id) { 1010 }
    let(:domain_id) { "example.com" }

    before do
      stub_request(:get, %r[/v2/#{account_id}/domains/#{domain_id}/email_forwards])
          .to_return(read_http_fixture("listEmailForwards/success.http"))
    end

    it "builds the correct request" do
      subject.email_forwards(account_id, domain_id)

      expect(WebMock).to have_requested(:get, "https://api.dnsimple.test/v2/#{account_id}/domains/#{domain_id}/email_forwards")
          .with(headers: { 'Accept' => 'application/json' })
    end

    it "supports pagination" do
      subject.email_forwards(account_id, domain_id, query: { page: 2 })

      expect(WebMock).to have_requested(:get, "https://api.dnsimple.test/v2/#{account_id}/domains/#{domain_id}/email_forwards?page=2")
    end

    it "supports extra request options" do
      subject.email_forwards(account_id, domain_id, query: { foo: "bar" })

      expect(WebMock).to have_requested(:get, "https://api.dnsimple.test/v2/#{account_id}/domains/#{domain_id}/email_forwards?foo=bar")
    end

    it "returns the email forwards" do
      response = subject.email_forwards(account_id, domain_id)

      expect(response).to be_a(Dnsimple::PaginatedResponse)
      expect(response.data).to be_a(Array)
      expect(response.data.size).to eq(2)

      response.data.each do |result|
        expect(result).to be_a(Dnsimple::Struct::EmailForward)
        expect(result.id).to be_a(Fixnum)
      end
    end
  end
end
