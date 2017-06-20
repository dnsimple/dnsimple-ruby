require 'spec_helper'

describe Dnsimple::Client, ".domains" do

  subject { described_class.new(base_url: "https://api.dnsimple.test", access_token: "a1b2c3").domains }

  describe "#initiate_push" do
    let(:account_id) { 1010 }
    let(:domain_id) { "example.com" }

    before do
      stub_request(:post, %r{/v2/#{account_id}/domains/#{domain_id}/pushes$})
          .to_return(read_http_fixture("initiatePush/success.http"))
    end

    let(:attributes) { { new_account_email: "admin@target-account.test" } }

    it "builds the correct request" do
      subject.initiate_push(account_id, domain_id, attributes)

      expect(WebMock).to have_requested(:post, "https://api.dnsimple.test/v2/#{account_id}/domains/#{domain_id}/pushes")
          .with(body: attributes)
          .with(headers: { 'Accept' => 'application/json' })
    end

    it "returns the domain push" do
      response = subject.initiate_push(account_id, domain_id, attributes)
      expect(response).to be_a(Dnsimple::Response)

      result = response.data
      expect(result).to be_a(Dnsimple::Struct::DomainPush)
      expect(result.id).to be_a(Integer)
    end
  end

  describe "#pushes" do
    let(:account_id) { 2020 }

    before do
      stub_request(:get, %r{/v2/#{account_id}/pushes})
          .to_return(read_http_fixture("listPushes/success.http"))
    end

    it "builds the correct request" do
      subject.pushes(account_id)

      expect(WebMock).to have_requested(:get, "https://api.dnsimple.test/v2/#{account_id}/pushes")
          .with(headers: { 'Accept' => 'application/json' })
    end

    it "supports pagination" do
      subject.pushes(account_id, page: 2)

      expect(WebMock).to have_requested(:get, "https://api.dnsimple.test/v2/#{account_id}/pushes?page=2")
    end

    it "supports extra request options" do
      subject.pushes(account_id, query: { foo: "bar" })

      expect(WebMock).to have_requested(:get, "https://api.dnsimple.test/v2/#{account_id}/pushes?foo=bar")
    end

    it "returns a list of domain pushes" do
      response = subject.pushes(account_id)

      expect(response).to be_a(Dnsimple::PaginatedResponse)
      expect(response.data).to be_a(Array)
      expect(response.data.size).to eq(2)

      response.data.each do |result|
        expect(result).to be_a(Dnsimple::Struct::DomainPush)
        expect(result.id).to be_a(Integer)
      end
    end

    it "exposes the pagination information" do
      response = subject.pushes(account_id)

      expect(response.respond_to?(:page)).to be_truthy
      expect(response.page).to eq(1)
      expect(response.per_page).to be_a(Integer)
      expect(response.total_entries).to be_a(Integer)
      expect(response.total_pages).to be_a(Integer)
    end
  end

  describe "#accept_push" do
    let(:account_id) { 2020 }
    let(:push_id) { 1 }

    before do
      stub_request(:post, %r{/v2/#{account_id}/pushes/#{push_id}$})
          .to_return(read_http_fixture("acceptPush/success.http"))
    end

    let(:attributes) { { contact_id: 2 } }

    it "builds the correct request" do
      subject.accept_push(account_id, push_id, attributes)

      expect(WebMock).to have_requested(:post, "https://api.dnsimple.test/v2/#{account_id}/pushes/#{push_id}")
          .with(body: attributes)
          .with(headers: { 'Accept' => 'application/json' })
    end

    it "returns nothing" do
      response = subject.accept_push(account_id, push_id, attributes)
      expect(response).to be_a(Dnsimple::Response)

      result = response.data
      expect(result).to be_nil
    end

    context "when the domain push does not exist" do
      it "raises NotFoundError" do
        stub_request(:post, %r{/v2})
            .to_return(read_http_fixture("notfound-domainpush.http"))

        expect {
          subject.accept_push(account_id, push_id, attributes)
        }.to raise_error(Dnsimple::NotFoundError)
      end
    end
  end

  describe "#reject_push" do
    let(:account_id) { 2020 }
    let(:push_id) { 1 }

    before do
      stub_request(:delete, %r{/v2/#{account_id}/pushes/#{push_id}$})
          .to_return(read_http_fixture("rejectPush/success.http"))
    end

    it "builds the correct request" do
      subject.reject_push(account_id, push_id)

      expect(WebMock).to have_requested(:delete, "https://api.dnsimple.test/v2/#{account_id}/pushes/#{push_id}")
          .with(headers: { 'Accept' => 'application/json' })
    end

    it "returns nothing" do
      response = subject.reject_push(account_id, push_id)
      expect(response).to be_a(Dnsimple::Response)

      result = response.data
      expect(result).to be_nil
    end

    context "when the domain push does not exist" do
      it "raises NotFoundError" do
        stub_request(:delete, %r{/v2})
            .to_return(read_http_fixture("notfound-domainpush.http"))

        expect {
          subject.reject_push(account_id, push_id)
        }.to raise_error(Dnsimple::NotFoundError)
      end
    end
  end

end
