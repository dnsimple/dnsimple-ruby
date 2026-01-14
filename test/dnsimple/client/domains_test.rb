# frozen_string_literal: true

require "test_helper"

describe Dnsimple::Client, ".domains" do

  let(:subject) { Dnsimple::Client.new(base_url: "https://api.dnsimple.test", access_token: "a1b2c3").domains }


  describe "#domains" do
    let(:account_id) { 1010 }

    before do
      stub_request(:get, %r{/v2/#{account_id}/domains})
          .to_return(read_http_fixture("listDomains/success.http"))
    end

    it "builds the correct request" do
      subject.domains(account_id)

      assert_requested(:get, "https://api.dnsimple.test/v2/#{account_id}/domains",
                       headers: { "Accept" => "application/json" })
    end

    it "supports pagination" do
      subject.domains(account_id, page: 2)

      assert_requested(:get, "https://api.dnsimple.test/v2/#{account_id}/domains?page=2")
    end

    it "supports extra request options" do
      subject.domains(account_id, query: { foo: "bar" })

      assert_requested(:get, "https://api.dnsimple.test/v2/#{account_id}/domains?foo=bar")
    end

    it "supports sorting" do
      subject.domains(account_id, sort: "expiration:asc")

      assert_requested(:get, "https://api.dnsimple.test/v2/#{account_id}/domains?sort=expiration:asc")
    end

    it "supports filtering" do
      subject.domains(account_id, filter: { name_like: "example" })

      assert_requested(:get, "https://api.dnsimple.test/v2/#{account_id}/domains?name_like=example")
    end

    it "returns the domains" do
      response = subject.domains(account_id)

      _(response).must_be_kind_of(Dnsimple::PaginatedResponse)
      _(response.data).must_be_kind_of(Array)
      _(response.data.size).must_equal(2)

      response.data.each do |result|
        _(result).must_be_kind_of(Dnsimple::Struct::Domain)
        _(result.id).must_be_kind_of(Integer)
      end
    end

    it "exposes the pagination information" do
      response = subject.domains(account_id)

      _(response).must_respond_to(:page)
      _(response.page).must_equal(1)
      _(response.per_page).must_be_kind_of(Integer)
      _(response.total_entries).must_be_kind_of(Integer)
      _(response.total_pages).must_be_kind_of(Integer)
    end
  end

  describe "#all_domains" do
    before do
      stub_request(:get, %r{/v2/#{account_id}/domains})
          .to_return(read_http_fixture("listDomains/success.http"))
    end

    let(:account_id) { 1010 }

    it "delegates to client.paginate" do
      mock = Minitest::Mock.new
      mock.expect(:call, nil, [:domains, account_id, { foo: "bar" }])
      subject.stub(:paginate, mock) do
        subject.all_domains(account_id, { foo: "bar" })
      end
      mock.verify
    end

    it "supports sorting" do
      subject.all_domains(account_id, sort: "expiration:asc")

      assert_requested(:get, "https://api.dnsimple.test/v2/#{account_id}/domains?page=1&per_page=100&sort=expiration:asc")
    end

    it "supports filtering" do
      subject.all_domains(account_id, filter: { registrant_id: 99 })

      assert_requested(:get, "https://api.dnsimple.test/v2/#{account_id}/domains?page=1&per_page=100&registrant_id=99")
    end
  end

  describe "#create_domain" do
    let(:account_id) { 1010 }
    let(:attributes) { { name: "example.com" } }

    before do
      stub_request(:post, %r{/v2/#{account_id}/domains$})
          .to_return(read_http_fixture("createDomain/created.http"))
    end


    it "builds the correct request" do
      subject.create_domain(account_id, attributes)

      assert_requested(:post, "https://api.dnsimple.test/v2/#{account_id}/domains",
                       body: attributes,
                       headers: { "Accept" => "application/json" })
    end

    it "returns the domain" do
      response = subject.create_domain(account_id, attributes)
      _(response).must_be_kind_of(Dnsimple::Response)

      result = response.data
      _(result).must_be_kind_of(Dnsimple::Struct::Domain)
      _(result.id).must_be_kind_of(Integer)
    end
  end

  describe "#domain" do
    let(:account_id) { 1010 }

    before do
      stub_request(:get, %r{/v2/#{account_id}/domains/.+$})
          .to_return(read_http_fixture("getDomain/success.http"))
    end

    it "builds the correct request" do
      subject.domain(account_id, domain = "example-alpha.com")

      assert_requested(:get, "https://api.dnsimple.test/v2/#{account_id}/domains/#{domain}",
                       headers: { "Accept" => "application/json" })
    end

    it "returns the domain" do
      response = subject.domain(account_id, "example-alpha.com")
      _(response).must_be_kind_of(Dnsimple::Response)

      result = response.data
      _(result).must_be_kind_of(Dnsimple::Struct::Domain)
      _(result.id).must_equal(181984)
      _(result.account_id).must_equal(1385)
      _(result.registrant_id).must_equal(2715)
      _(result.name).must_equal("example-alpha.com")
      _(result.state).must_equal("registered")
      _(result.auto_renew).must_equal(false)
      _(result.private_whois).must_equal(false)
      _(result.expires_at).must_equal("2021-06-05T02:15:00Z")
      _(result.created_at).must_equal("2020-06-04T19:15:14Z")
      _(result.updated_at).must_equal("2020-06-04T19:15:21Z")
    end

    describe "when the domain does not exist" do
      it "raises NotFoundError" do
        stub_request(:get, %r{/v2})
            .to_return(read_http_fixture("notfound-domain.http"))

        _ {
          subject.domain(account_id, "example.com")
        }.must_raise(Dnsimple::NotFoundError)
      end
    end
  end

  describe "#delete_domain" do
    let(:account_id) { 1010 }

    before do
      stub_request(:delete, %r{/v2/#{account_id}/domains/.+$})
          .to_return(read_http_fixture("deleteDomain/success.http"))
    end

    it "builds the correct request" do
      subject.delete_domain(account_id, domain = "example.com")

      assert_requested(:delete, "https://api.dnsimple.test/v2/#{account_id}/domains/#{domain}",
                       headers: { "Accept" => "application/json" })
    end

    it "returns nothing" do
      response = subject.delete_domain(account_id, "example.com")
      _(response).must_be_kind_of(Dnsimple::Response)

      result = response.data
      _(result).must_be_nil
    end

    describe "when the domain does not exist" do
      it "raises NotFoundError" do
        stub_request(:delete, %r{/v2})
            .to_return(read_http_fixture("notfound-domain.http"))

        _ {
          subject.delete_domain(account_id, "example.com")
        }.must_raise(Dnsimple::NotFoundError)
      end
    end
  end
end
