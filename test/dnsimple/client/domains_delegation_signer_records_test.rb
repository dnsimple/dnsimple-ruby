# frozen_string_literal: true

require "test_helper"

describe Dnsimple::Client, ".domains" do

  let(:subject) { Dnsimple::Client.new(base_url: "https://api.dnsimple.test", access_token: "a1b2c3").domains }


  describe "#delegation_signer_records" do
    let(:account_id) { 1010 }
    let(:domain_id) { "example.com" }

    before do
      stub_request(:get, %r{/v2/#{account_id}/domains/#{domain_id}/ds_records})
          .to_return(read_http_fixture("listDelegationSignerRecords/success.http"))
    end

    it "builds the correct request" do
      subject.delegation_signer_records(account_id, domain_id)

      assert_requested(:get, "https://api.dnsimple.test/v2/#{account_id}/domains/#{domain_id}/ds_records",
                       headers: { "Accept" => "application/json" })
    end

    it "supports pagination" do
      subject.delegation_signer_records(account_id, domain_id, page: 2)

      assert_requested(:get, "https://api.dnsimple.test/v2/#{account_id}/domains/#{domain_id}/ds_records?page=2")
    end

    it "supports extra request options" do
      subject.delegation_signer_records(account_id, domain_id, query: { foo: "bar" })

      assert_requested(:get, "https://api.dnsimple.test/v2/#{account_id}/domains/#{domain_id}/ds_records?foo=bar")
    end

    it "supports sorting" do
      subject.delegation_signer_records(account_id, domain_id, sort: "id:asc,from:desc")

      assert_requested(:get, "https://api.dnsimple.test/v2/#{account_id}/domains/#{domain_id}/ds_records?sort=id:asc,from:desc")
    end

    it "returns the delegation signer records" do
      response = subject.delegation_signer_records(account_id, domain_id)

      _(response).must_be_kind_of(Dnsimple::PaginatedResponse)
      _(response.data).must_be_kind_of(Array)
      _(response.data.size).must_equal(1)

      response.data.each do |result|
        _(result).must_be_kind_of(Dnsimple::Struct::DelegationSignerRecord)
        _(result.id).must_be_kind_of(Integer)
      end
    end

    it "exposes the pagination information" do
      response = subject.delegation_signer_records(account_id, domain_id)

      _(response).must_respond_to(:page)
      _(response.page).must_equal(1)
      _(response.per_page).must_be_kind_of(Integer)
      _(response.total_entries).must_be_kind_of(Integer)
      _(response.total_pages).must_be_kind_of(Integer)
    end

    describe "when the domain does not exist" do
      it "raises NotFoundError" do
        stub_request(:get, %r{/v2})
            .to_return(read_http_fixture("notfound-domain.http"))

        _ {
          subject.delegation_signer_records(account_id, domain_id)
        }.must_raise(Dnsimple::NotFoundError)
      end
    end
  end

  describe "#all_delegation_signer_records" do
    before do
      stub_request(:get, %r{/v2/#{account_id}/domains/#{domain_id}/ds_records})
          .to_return(read_http_fixture("listDelegationSignerRecords/success.http"))
    end

    let(:account_id) { 1010 }
    let(:domain_id) { "example.com" }

    it "delegates to client.paginate" do
      mock = Minitest::Mock.new
      mock.expect(:call, nil, [:delegation_signer_records, account_id, domain_id, { foo: "bar" }])
      subject.stub(:paginate, mock) do
        subject.all_delegation_signer_records(account_id, domain_id, { foo: "bar" })
      end
      mock.verify
    end

    it "supports sorting" do
      subject.all_delegation_signer_records(account_id, domain_id, sort: "id:asc,from:desc")

      assert_requested(:get, "https://api.dnsimple.test/v2/#{account_id}/domains/#{domain_id}/ds_records?page=1&per_page=100&sort=id:asc,from:desc")
    end
  end

  describe "#create_delegation_signer_record" do
    let(:account_id) { 1010 }
    let(:attributes) { { algorithm: "13", digest: "ABC123", digest_type: "2", keytag: "1111" } }
    let(:domain_id) { "example.com" }

    before do
      stub_request(:post, %r{/v2/#{account_id}/domains/#{domain_id}/ds_records$})
          .to_return(read_http_fixture("createDelegationSignerRecord/created.http"))
    end


    it "builds the correct request" do
      subject.create_delegation_signer_record(account_id, domain_id, attributes)

      assert_requested(:post, "https://api.dnsimple.test/v2/#{account_id}/domains/#{domain_id}/ds_records",
                       body: attributes,
                       headers: { "Accept" => "application/json" })
    end

    it "returns the delegation signer record" do
      response = subject.create_delegation_signer_record(account_id, domain_id, attributes)
      _(response).must_be_kind_of(Dnsimple::Response)

      result = response.data
      _(result).must_be_kind_of(Dnsimple::Struct::DelegationSignerRecord)
      _(result.id).must_be_kind_of(Integer)
    end
  end

  describe "#delegation_signer_record" do
    let(:account_id) { 1010 }
    let(:domain_id) { "example.com" }
    let(:ds_record_id) { 24 }

    before do
      stub_request(:get, %r{/v2/#{account_id}/domains/#{domain_id}/ds_records.+$})
          .to_return(read_http_fixture("getDelegationSignerRecord/success.http"))
    end

    it "builds the correct request" do
      subject.delegation_signer_record(account_id, domain_id, ds_record_id)

      assert_requested(:get, "https://api.dnsimple.test/v2/#{account_id}/domains/#{domain_id}/ds_records/#{ds_record_id}",
                       headers: { "Accept" => "application/json" })
    end

    it "returns the delegation signer record" do
      response = subject.delegation_signer_record(account_id, domain_id, ds_record_id)
      _(response).must_be_kind_of(Dnsimple::Response)

      result = response.data
      _(result).must_be_kind_of(Dnsimple::Struct::DelegationSignerRecord)
      _(result.id).must_equal(24)
      _(result.domain_id).must_equal(1010)
      _(result.algorithm).must_equal("8")
      _(result.digest).must_equal("C1F6E04A5A61FBF65BF9DC8294C363CF11C89E802D926BDAB79C55D27BEFA94F")
      _(result.digest_type).must_equal("2")
      _(result.keytag).must_equal("44620")
      _(result.public_key).must_be_nil
      _(result.created_at).must_equal("2017-03-03T13:49:58Z")
      _(result.updated_at).must_equal("2017-03-03T13:49:58Z")
    end

    describe "when the delegation signer record does not exist" do
      it "raises NotFoundError" do
        stub_request(:get, %r{/v2})
            .to_return(read_http_fixture("notfound-delegationSignerRecord.http"))

        _ {
          subject.delegation_signer_record(account_id, domain_id, ds_record_id)
        }.must_raise(Dnsimple::NotFoundError)
      end
    end
  end

  describe "#delete_delegation_signer_record" do
    let(:account_id) { 1010 }
    let(:domain_id) { "example.com" }
    let(:ds_record_id) { 1 }

    before do
      stub_request(:delete, %r{/v2/#{account_id}/domains/#{domain_id}/ds_records/#{ds_record_id}$})
          .to_return(read_http_fixture("deleteDelegationSignerRecord/success.http"))
    end

    it "builds the correct request" do
      subject.delete_delegation_signer_record(account_id, domain_id, ds_record_id)

      assert_requested(:delete, "https://api.dnsimple.test/v2/#{account_id}/domains/#{domain_id}/ds_records/#{ds_record_id}",
                       headers: { "Accept" => "application/json" })
    end

    it "returns nothing" do
      response = subject.delete_delegation_signer_record(account_id, domain_id, ds_record_id)
      _(response).must_be_kind_of(Dnsimple::Response)

      result = response.data
      _(result).must_be_nil
    end

    describe "when the delegation signer record does not exist" do
      it "raises NotFoundError" do
        stub_request(:delete, %r{/v2})
            .to_return(read_http_fixture("notfound-delegationSignerRecord.http"))

        _ {
          subject.delete_delegation_signer_record(account_id, domain_id, ds_record_id)
        }.must_raise(Dnsimple::NotFoundError)
      end
    end
  end

end
