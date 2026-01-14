# frozen_string_literal: true

require "test_helper"

describe Dnsimple::Client, ".tlds" do
  let(:subject) { Dnsimple::Client.new(base_url: "https://api.dnsimple.test", access_token: "a1b2c3").tlds }

  describe "#list_tlds" do
    before do
      stub_request(:get, %r{/v2/tlds})
          .to_return(read_http_fixture("listTlds/success.http"))
    end

    it "builds the correct request" do
      subject.list_tlds

      assert_requested(:get, "https://api.dnsimple.test/v2/tlds",
                       headers: { "Accept" => "application/json" })
    end

    it "supports pagination" do
      subject.list_tlds(page: 2)

      assert_requested(:get, "https://api.dnsimple.test/v2/tlds?page=2")
    end

    it "supports additional options" do
      subject.list_tlds(query: { foo: "bar" })

      assert_requested(:get, "https://api.dnsimple.test/v2/tlds?foo=bar")
    end

    it "supports sorting" do
      subject.list_tlds(sort: "tld:asc")

      assert_requested(:get, "https://api.dnsimple.test/v2/tlds?sort=tld:asc")
    end

    it "returns the tlds" do
      response = subject.list_tlds

      _(response).must_be_kind_of(Dnsimple::PaginatedResponse)
      _(response.data).must_be_kind_of(Array)
      _(response.data.size).must_equal(2)

      response.data.each do |result|
        _(result).must_be_kind_of(Dnsimple::Struct::Tld)
        _(result.tld_type).must_be_kind_of(Integer)
        _(result.tld).must_be_kind_of(String)
      end
    end

    it "exposes the pagination information" do
      response = subject.list_tlds

      _(response).must_respond_to(:page)
      _(response.page).must_equal(1)
      _(response.per_page).must_be_kind_of(Integer)
      _(response.total_entries).must_be_kind_of(Integer)
      _(response.total_pages).must_be_kind_of(Integer)
    end
  end

  describe "#all_tlds" do
    before do
      stub_request(:get, %r{/v2/tlds})
          .to_return(read_http_fixture("listTlds/success.http"))
    end

    it "delegates to client.paginate" do
      mock = Minitest::Mock.new
      mock.expect(:call, nil, [:list_tlds, { foo: "bar" }])
      subject.stub(:paginate, mock) do
        subject.all_tlds(foo: "bar")
      end
      mock.verify
    end

    it "supports sorting" do
      subject.all_tlds(sort: "tld:asc")

      assert_requested(:get, "https://api.dnsimple.test/v2/tlds?page=1&per_page=100&sort=tld:asc")
    end
  end

  describe "#tld" do
    before do
      stub_request(:get, %r{/v2/tlds/.+$})
          .to_return(read_http_fixture("getTld/success.http"))
    end

    it "builds the correct request" do
      subject.tld(tld = "com")

      assert_requested(:get, "https://api.dnsimple.test/v2/tlds/#{tld}",
                       headers: { "Accept" => "application/json" })
    end

    it "returns the tld" do
      response = subject.tld("com")
      _(response).must_be_kind_of(Dnsimple::Response)

      result = response.data
      _(result).must_be_kind_of(Dnsimple::Struct::Tld)
      _(result.tld).must_equal("com")
      _(result.tld_type).must_equal(1)
      _(result.whois_privacy).must_equal(true)
      _(result.auto_renew_only).must_equal(false)
      _(result.idn).must_equal(true)
      _(result.minimum_registration).must_equal(1)
      _(result.registration_enabled).must_equal(true)
      _(result.renewal_enabled).must_equal(true)
      _(result.transfer_enabled).must_equal(true)
      _(result.dnssec_interface_type).must_equal("ds")
    end
  end

  describe "#tld_extended_attributes" do
    before do
      stub_request(:get, %r{/v2/tlds/uk/extended_attributes$})
          .to_return(read_http_fixture("getTldExtendedAttributes/success.http"))
    end

    it "builds the correct request" do
      subject.tld_extended_attributes(tld = "uk")

      assert_requested(:get, "https://api.dnsimple.test/v2/tlds/#{tld}/extended_attributes",
                       headers: { "Accept" => "application/json" })
    end

    it "returns the extended attributes" do
      response = subject.tld_extended_attributes("uk")
      _(response).must_be_kind_of(Dnsimple::CollectionResponse)

      response.data.each do |result|
        _(result).must_be_kind_of(Dnsimple::Struct::ExtendedAttribute)
        _(result.name).must_be_kind_of(String)
        _(result.description).must_be_kind_of(String)
        _(result).must_respond_to(:required)

        next if result.options.empty?

        result.options.each do |option|
          _(option).must_be_kind_of(Dnsimple::Struct::ExtendedAttribute::Option)
          _(option.title).must_be_kind_of(String)
          _(option.value).must_be_kind_of(String)
          _(option.description).must_be_kind_of(String)
        end
      end
    end

    describe "when there are no extended attributes for a TLD" do
      before do
        stub_request(:get, %r{/v2/tlds/com/extended_attributes$})
            .to_return(read_http_fixture("getTldExtendedAttributes/success-noattributes.http"))
      end

      it "returns an empty CollectionResponse" do
        response = subject.tld_extended_attributes("com")
        _(response).must_be_kind_of(Dnsimple::CollectionResponse)

        result = response.data
        _(result).must_be_empty
      end
    end
  end
end
