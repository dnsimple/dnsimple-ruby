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

  describe "#create_email_forward" do
    let(:account_id) { 1010 }
    let(:domain_id) { "example.com" }

    before do
      stub_request(:post, %r[/v2/#{account_id}/domains/#{domain_id}/email_forwards$])
          .to_return(read_http_fixture("createEmailForward/created.http"))
    end

    let(:attributes) { { from: "jim", to: "jim@another.com" } }

    it "builds the correct request" do
      subject.create_email_forward(account_id, domain_id, attributes)

      expect(WebMock).to have_requested(:post, "https://api.dnsimple.test/v2/#{account_id}/domains/#{domain_id}/email_forwards")
          .with(body: attributes)
          .with(headers: { 'Accept' => 'application/json' })
    end

    it "returns the email forward" do
      response = subject.create_email_forward(account_id, domain_id, attributes)
      expect(response).to be_a(Dnsimple::Response)

      result = response.data
      expect(result).to be_a(Dnsimple::Struct::EmailForward)
      expect(result.id).to be_a(Fixnum)
    end
  end

  describe "#email_forward" do
    let(:account_id) { 1010 }
    let(:domain_id) { "example.com" }
    let(:email_forward_id) { 17706 }

    before do
      stub_request(:get, %r[/v2/#{account_id}/domains/#{domain_id}/email_forwards.+$])
          .to_return(read_http_fixture("getEmailForward/success.http"))
    end

    it "builds the correct request" do
      subject.email_forward(account_id, domain_id, email_forward_id)

      expect(WebMock).to have_requested(:get, "https://api.dnsimple.test/v2/#{account_id}/domains/#{domain_id}/email_forwards/#{email_forward_id}")
          .with(headers: { 'Accept' => 'application/json' })
    end

    it "returns the email forward" do
      response = subject.email_forward(account_id, domain_id, email_forward_id)
      expect(response).to be_a(Dnsimple::Response)

      result = response.data
      expect(result).to be_a(Dnsimple::Struct::EmailForward)
      expect(result.id).to eq(17706)
      expect(result.domain_id).to eq(228963)
      expect(result.from).to eq("jim@a-domain.com")
      expect(result.to).to eq("jim@another.com")
      expect(result.created_at).to eq("2016-02-04T14:26:50.282Z")
      expect(result.updated_at).to eq("2016-02-04T14:26:50.282Z")
    end

    context "when the email forward does not exist" do
      it "raises NotFoundError" do
        stub_request(:get, %r[/v2])
            .to_return(read_http_fixture("notfound-emailforward.http"))

        expect {
          subject.email_forward(account_id, domain_id, email_forward_id)
        }.to raise_error(Dnsimple::NotFoundError)
      end
    end
  end

  describe "#delete_email_forward" do
    let(:account_id) { 1010 }
    let(:domain_id) { "example.com" }
    let(:email_forward_id) { 1 }

    before do
      stub_request(:delete, %r[/v2/#{account_id}/domains/#{domain_id}/email_forwards/#{email_forward_id}$])
          .to_return(read_http_fixture("deleteEmailForward/success.http"))
    end

    it "builds the correct request" do
      subject.delete_email_forward(account_id, domain_id, email_forward_id)

      expect(WebMock).to have_requested(:delete, "https://api.dnsimple.test/v2/#{account_id}/domains/#{domain_id}/email_forwards/#{email_forward_id}")
          .with(headers: { 'Accept' => 'application/json' })
    end

    it "returns nothing" do
      response = subject.delete_email_forward(account_id, domain_id, email_forward_id)
      expect(response).to be_a(Dnsimple::Response)

      result = response.data
      expect(result).to be_nil
    end

    context "when the email forward does not exist" do
      it "raises NotFoundError" do
        stub_request(:delete, %r[/v2])
            .to_return(read_http_fixture("notfound-emailforward.http"))

        expect {
          subject.delete_email_forward(account_id, domain_id, email_forward_id)
        }.to raise_error(Dnsimple::NotFoundError)
      end
    end
  end

end
