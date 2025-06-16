# frozen_string_literal: true

require "spec_helper"

describe Dnsimple::Client, ".domains" do

  subject { described_class.new(base_url: "https://api.dnsimple.test", access_token: "a1b2c3").domains }


  describe "#delegation_signer_records" do
    let(:account_id) { 1010 }
    let(:domain_id) { "example.com" }

    before do
      stub_request(:get, %r{/v2/#{account_id}/domains/#{domain_id}/ds_records})
          .to_return(read_http_fixture("listDelegationSignerRecords/success.http"))
    end

    it "builds the correct request" do
      subject.delegation_signer_records(account_id, domain_id)

      expect(WebMock).to have_requested(:get, "https://api.dnsimple.test/v2/#{account_id}/domains/#{domain_id}/ds_records")
          .with(headers: { "Accept" => "application/json" })
    end

    it "supports pagination" do
      subject.delegation_signer_records(account_id, domain_id, page: 2)

      expect(WebMock).to have_requested(:get, "https://api.dnsimple.test/v2/#{account_id}/domains/#{domain_id}/ds_records?page=2")
    end

    it "supports extra request options" do
      subject.delegation_signer_records(account_id, domain_id, query: { foo: "bar" })

      expect(WebMock).to have_requested(:get, "https://api.dnsimple.test/v2/#{account_id}/domains/#{domain_id}/ds_records?foo=bar")
    end

    it "supports sorting" do
      subject.delegation_signer_records(account_id, domain_id, sort: "id:asc,from:desc")

      expect(WebMock).to have_requested(:get, "https://api.dnsimple.test/v2/#{account_id}/domains/#{domain_id}/ds_records?sort=id:asc,from:desc")
    end

    it "returns the delegation signer records" do
      response = subject.delegation_signer_records(account_id, domain_id)

      expect(response).to be_a(Dnsimple::PaginatedResponse)
      expect(response.data).to be_a(Array)
      expect(response.data.size).to eq(1)

      response.data.each do |result|
        expect(result).to be_a(Dnsimple::Struct::DelegationSignerRecord)
        expect(result.id).to be_a(Integer)
      end
    end

    it "exposes the pagination information" do
      response = subject.delegation_signer_records(account_id, domain_id)

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
          subject.delegation_signer_records(account_id, domain_id)
        }.to raise_error(Dnsimple::NotFoundError)
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
      expect(subject).to receive(:paginate).with(:delegation_signer_records, account_id, domain_id, { foo: "bar" })
      subject.all_delegation_signer_records(account_id, domain_id, { foo: "bar" })
    end

    it "supports sorting" do
      subject.all_delegation_signer_records(account_id, domain_id, sort: "id:asc,from:desc")

      expect(WebMock).to have_requested(:get, "https://api.dnsimple.test/v2/#{account_id}/domains/#{domain_id}/ds_records?page=1&per_page=100&sort=id:asc,from:desc")
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

      expect(WebMock).to have_requested(:post, "https://api.dnsimple.test/v2/#{account_id}/domains/#{domain_id}/ds_records")
          .with(body: attributes)
          .with(headers: { "Accept" => "application/json" })
    end

    it "returns the delegation signer record" do
      response = subject.create_delegation_signer_record(account_id, domain_id, attributes)
      expect(response).to be_a(Dnsimple::Response)

      result = response.data
      expect(result).to be_a(Dnsimple::Struct::DelegationSignerRecord)
      expect(result.id).to be_a(Integer)
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

      expect(WebMock).to have_requested(:get, "https://api.dnsimple.test/v2/#{account_id}/domains/#{domain_id}/ds_records/#{ds_record_id}")
          .with(headers: { "Accept" => "application/json" })
    end

    it "returns the delegation signer record" do
      response = subject.delegation_signer_record(account_id, domain_id, ds_record_id)
      expect(response).to be_a(Dnsimple::Response)

      result = response.data
      expect(result).to be_a(Dnsimple::Struct::DelegationSignerRecord)
      expect(result.id).to eq(24)
      expect(result.domain_id).to eq(1010)
      expect(result.algorithm).to eq("8")
      expect(result.digest).to eq("C1F6E04A5A61FBF65BF9DC8294C363CF11C89E802D926BDAB79C55D27BEFA94F")
      expect(result.digest_type).to eq("2")
      expect(result.keytag).to eq("44620")
      expect(result.public_key).to be_nil
      expect(result.created_at).to eq("2017-03-03T13:49:58Z")
      expect(result.updated_at).to eq("2017-03-03T13:49:58Z")
    end

    context "when the delegation signer record does not exist" do
      it "raises NotFoundError" do
        stub_request(:get, %r{/v2})
            .to_return(read_http_fixture("notfound-delegationsignerrecord.http"))

        expect {
          subject.delegation_signer_record(account_id, domain_id, ds_record_id)
        }.to raise_error(Dnsimple::NotFoundError)
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

      expect(WebMock).to have_requested(:delete, "https://api.dnsimple.test/v2/#{account_id}/domains/#{domain_id}/ds_records/#{ds_record_id}")
          .with(headers: { "Accept" => "application/json" })
    end

    it "returns nothing" do
      response = subject.delete_delegation_signer_record(account_id, domain_id, ds_record_id)
      expect(response).to be_a(Dnsimple::Response)

      result = response.data
      expect(result).to be_nil
    end

    context "when the delegation signer record does not exist" do
      it "raises NotFoundError" do
        stub_request(:delete, %r{/v2})
            .to_return(read_http_fixture("notfound-delegationsignerrecord.http"))

        expect {
          subject.delete_delegation_signer_record(account_id, domain_id, ds_record_id)
        }.to raise_error(Dnsimple::NotFoundError)
      end
    end
  end

end
