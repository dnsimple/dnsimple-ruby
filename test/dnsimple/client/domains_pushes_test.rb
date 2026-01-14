# frozen_string_literal: true

require "test_helper"

describe Dnsimple::Client, ".domains" do

  let(:subject) { Dnsimple::Client.new(base_url: "https://api.dnsimple.test", access_token: "a1b2c3").domains }

  describe "#initiate_push" do
    let(:account_id) { 1010 }
    let(:attributes) { { new_account_email: "admin@target-account.test" } }
    let(:domain_id) { "example.com" }

    before do
      stub_request(:post, %r{/v2/#{account_id}/domains/#{domain_id}/pushes$})
          .to_return(read_http_fixture("initiatePush/success.http"))
    end


    it "builds the correct request" do
      subject.initiate_push(account_id, domain_id, attributes)

      assert_requested(:post, "https://api.dnsimple.test/v2/#{account_id}/domains/#{domain_id}/pushes",
                       body: attributes,
                       headers: { "Accept" => "application/json" })
    end

    it "returns the domain push" do
      response = subject.initiate_push(account_id, domain_id, attributes)
      _(response).must_be_kind_of(Dnsimple::Response)

      result = response.data
      _(result).must_be_kind_of(Dnsimple::Struct::DomainPush)
      _(result.id).must_be_kind_of(Integer)
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

      assert_requested(:get, "https://api.dnsimple.test/v2/#{account_id}/pushes",
                       headers: { "Accept" => "application/json" })
    end

    it "supports pagination" do
      subject.pushes(account_id, page: 2)

      assert_requested(:get, "https://api.dnsimple.test/v2/#{account_id}/pushes?page=2")
    end

    it "supports extra request options" do
      subject.pushes(account_id, query: { foo: "bar" })

      assert_requested(:get, "https://api.dnsimple.test/v2/#{account_id}/pushes?foo=bar")
    end

    it "returns a list of domain pushes" do
      response = subject.pushes(account_id)

      _(response).must_be_kind_of(Dnsimple::PaginatedResponse)
      _(response.data).must_be_kind_of(Array)
      _(response.data.size).must_equal(2)

      response.data.each do |result|
        _(result).must_be_kind_of(Dnsimple::Struct::DomainPush)
        _(result.id).must_be_kind_of(Integer)
      end
    end

    it "exposes the pagination information" do
      response = subject.pushes(account_id)

      _(response).must_respond_to(:page)
      _(response.page).must_equal(1)
      _(response.per_page).must_be_kind_of(Integer)
      _(response.total_entries).must_be_kind_of(Integer)
      _(response.total_pages).must_be_kind_of(Integer)
    end
  end

  describe "#accept_push" do
    let(:account_id) { 2020 }
    let(:attributes) { { contact_id: 2 } }
    let(:push_id) { 1 }

    before do
      stub_request(:post, %r{/v2/#{account_id}/pushes/#{push_id}$})
          .to_return(read_http_fixture("acceptPush/success.http"))
    end


    it "builds the correct request" do
      subject.accept_push(account_id, push_id, attributes)

      assert_requested(:post, "https://api.dnsimple.test/v2/#{account_id}/pushes/#{push_id}",
                       body: attributes,
                       headers: { "Accept" => "application/json" })
    end

    it "returns nothing" do
      response = subject.accept_push(account_id, push_id, attributes)
      _(response).must_be_kind_of(Dnsimple::Response)

      result = response.data
      _(result).must_be_nil
    end

    describe "when the domain push does not exist" do
      it "raises NotFoundError" do
        stub_request(:post, %r{/v2})
            .to_return(read_http_fixture("notfound-domainpush.http"))

        _ {
          subject.accept_push(account_id, push_id, attributes)
        }.must_raise(Dnsimple::NotFoundError)
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

      assert_requested(:delete, "https://api.dnsimple.test/v2/#{account_id}/pushes/#{push_id}",
                       headers: { "Accept" => "application/json" })
    end

    it "returns nothing" do
      response = subject.reject_push(account_id, push_id)
      _(response).must_be_kind_of(Dnsimple::Response)

      result = response.data
      _(result).must_be_nil
    end

    describe "when the domain push does not exist" do
      it "raises NotFoundError" do
        stub_request(:delete, %r{/v2})
            .to_return(read_http_fixture("notfound-domainpush.http"))

        _ {
          subject.reject_push(account_id, push_id)
        }.must_raise(Dnsimple::NotFoundError)
      end
    end
  end

end
