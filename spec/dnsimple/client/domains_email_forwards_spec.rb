# frozen_string_literal: true

require 'spec_helper'

describe Dnsimple::Client, ".domains" do

  subject { described_class.new(base_url: "https://api.dnsimple.test", access_token: "a1b2c3").domains }


  describe "#email_forwards" do
    let(:account_id) { 1010 }
    let(:domain_id) { "example.com" }

    before do
      stub_request(:get, %r{/v2/#{account_id}/domains/#{domain_id}/email_forwards})
          .to_return(read_http_fixture("listEmailForwards/success.http"))
    end

    it "builds the correct request" do
      subject.email_forwards(account_id, domain_id)

      expect(WebMock).to have_requested(:get, "https://api.dnsimple.test/v2/#{account_id}/domains/#{domain_id}/email_forwards")
          .with(headers: { 'Accept' => 'application/json' })
    end

    it "supports pagination" do
      subject.email_forwards(account_id, domain_id, page: 2)

      expect(WebMock).to have_requested(:get, "https://api.dnsimple.test/v2/#{account_id}/domains/#{domain_id}/email_forwards?page=2")
    end

    it "supports extra request options" do
      subject.email_forwards(account_id, domain_id, query: { foo: "bar" })

      expect(WebMock).to have_requested(:get, "https://api.dnsimple.test/v2/#{account_id}/domains/#{domain_id}/email_forwards?foo=bar")
    end

    it "supports sorting" do
      subject.email_forwards(account_id, domain_id, sort: "id:asc,from:desc")

      expect(WebMock).to have_requested(:get, "https://api.dnsimple.test/v2/#{account_id}/domains/#{domain_id}/email_forwards?sort=id:asc,from:desc")
    end

    it "returns the email forwards" do
      response = subject.email_forwards(account_id, domain_id)

      expect(response).to be_a(Dnsimple::PaginatedResponse)
      expect(response.data).to be_a(Array)
      expect(response.data.size).to eq(2)

      response.data.each do |result|
        expect(result).to be_a(Dnsimple::Struct::EmailForward)
        expect(result.id).to be_a(Integer)
      end
    end

    it "exposes the pagination information" do
      response = subject.email_forwards(account_id, domain_id)

      expect(response.respond_to?(:page)).to be(true)
      expect(response.page).to eq(1)
      expect(response.per_page).to be_a(Integer)
      expect(response.total_entries).to be_a(Integer)
      expect(response.total_pages).to be_a(Integer)
    end

    context "when the domain does not exist" do
      it "raises NotFoundError" do
        stub_request(:get, %r{/v2})
            .to_return(read_http_fixture("notfound-domain.http"))

        expect {
          subject.email_forwards(account_id, domain_id)
        }.to raise_error(Dnsimple::NotFoundError)
      end
    end
  end

  describe "#all_email_forwards" do
    before do
      stub_request(:get, %r{/v2/#{account_id}/domains/#{domain_id}/email_forwards})
          .to_return(read_http_fixture("listEmailForwards/success.http"))
    end

    let(:account_id) { 1010 }
    let(:domain_id) { "example.com" }

    it "delegates to client.paginate" do
      expect(subject).to receive(:paginate).with(:email_forwards, account_id, domain_id, foo: "bar")
      subject.all_email_forwards(account_id, domain_id, foo: "bar")
    end

    it "supports sorting" do
      subject.all_email_forwards(account_id, domain_id, sort: "id:asc,from:desc")

      expect(WebMock).to have_requested(:get, "https://api.dnsimple.test/v2/#{account_id}/domains/#{domain_id}/email_forwards?page=1&per_page=100&sort=id:asc,from:desc")
    end
  end

  describe "#create_email_forward" do
    let(:account_id) { 1010 }
    let(:domain_id) { "example.com" }

    before do
      stub_request(:post, %r{/v2/#{account_id}/domains/#{domain_id}/email_forwards$})
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
      expect(result.id).to be_a(Integer)
    end
  end

  describe "#email_forward" do
    let(:account_id) { 1010 }
    let(:domain_id) { "example.com" }
    let(:email_forward_id) { 17706 }

    before do
      stub_request(:get, %r{/v2/#{account_id}/domains/#{domain_id}/email_forwards.+$})
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
      expect(result.created_at).to eq("2016-02-04T14:26:50Z")
      expect(result.updated_at).to eq("2016-02-04T14:26:50Z")
    end

    context "when the email forward does not exist" do
      it "raises NotFoundError" do
        stub_request(:get, %r{/v2})
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
      stub_request(:delete, %r{/v2/#{account_id}/domains/#{domain_id}/email_forwards/#{email_forward_id}$})
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
        stub_request(:delete, %r{/v2})
            .to_return(read_http_fixture("notfound-emailforward.http"))

        expect {
          subject.delete_email_forward(account_id, domain_id, email_forward_id)
        }.to raise_error(Dnsimple::NotFoundError)
      end
    end
  end

end
