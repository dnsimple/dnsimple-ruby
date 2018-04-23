require 'spec_helper'

describe Dnsimple::Client, ".domains" do

  subject { described_class.new(base_url: "https://api.dnsimple.test", access_token: "a1b2c3").domains }


  describe "#collaborators" do
    let(:account_id) { 1010 }
    let(:domain_id)  { "example.com" }

    before do
      stub_request(:get, %r{/v2/#{account_id}/domains/#{domain_id}/collaborators})
          .to_return(read_http_fixture("listCollaborators/success.http"))
    end

    it "builds the correct request" do
      subject.collaborators(account_id, domain_id)

      expect(WebMock).to have_requested(:get, "https://api.dnsimple.test/v2/#{account_id}/domains/#{domain_id}/collaborators")
          .with(headers: { 'Accept' => 'application/json' })
    end

    it "supports pagination" do
      subject.collaborators(account_id, domain_id, page: 2)

      expect(WebMock).to have_requested(:get, "https://api.dnsimple.test/v2/#{account_id}/domains/#{domain_id}/collaborators?page=2")
    end

    it "supports extra request options" do
      subject.collaborators(account_id, domain_id, query: { foo: "bar" })

      expect(WebMock).to have_requested(:get, "https://api.dnsimple.test/v2/#{account_id}/domains/#{domain_id}/collaborators?foo=bar")
    end

    it "returns the collaborators" do
      response = subject.collaborators(account_id, domain_id)

      expect(response).to be_a(Dnsimple::PaginatedResponse)
      expect(response.data).to be_a(Array)
      expect(response.data.size).to eq(2)

      response.data.each do |result|
        expect(result).to be_a(Dnsimple::Struct::Collaborator)
        expect(result.id).to be_a(Integer)
      end
    end

    it "exposes the pagination information" do
      response = subject.collaborators(account_id, domain_id)

      expect(response.respond_to?(:page)).to be(true)
      expect(response.page).to eq(1)
      expect(response.per_page).to be_a(Integer)
      expect(response.total_entries).to be_a(Integer)
      expect(response.total_pages).to be_a(Integer)
    end
  end

  describe "#add_collaborator" do
    let(:account_id) { 1010 }
    let(:domain_id)  { "example.com" }

    context "invite user already registered on DNSimple" do
      before do
        stub_request(:post, %r{/v2/#{account_id}/domains/#{domain_id}/collaborators$})
            .to_return(read_http_fixture("addCollaborator/success.http"))
      end

      let(:attributes) { { email: "existing-user@example.com" } }

      it "builds the correct request" do
        subject.add_collaborator(account_id, domain_id, attributes)

        expect(WebMock).to have_requested(:post, "https://api.dnsimple.test/v2/#{account_id}/domains/#{domain_id}/collaborators")
            .with(body: attributes)
            .with(headers: { 'Accept' => 'application/json' })
      end

      it "returns the contact" do
        response = subject.add_collaborator(account_id, domain_id, attributes)
        expect(response).to be_a(Dnsimple::Response)

        result = response.data
        expect(result).to be_a(Dnsimple::Struct::Collaborator)
        expect(result.id).to          be_a(Integer)
        expect(result.user_id).to     be_a(Integer)
        expect(result.accepted_at).to be_a(String)
        expect(result.user_email).to  eq(attributes.fetch(:email))
        expect(result.invitation).to  be(false)
      end
    end

    context "invite not registered on DNSimple" do
      before do
        stub_request(:post, %r{/v2/#{account_id}/domains/#{domain_id}/collaborators$})
            .to_return(read_http_fixture("addCollaborator/invite-success.http"))
      end

      let(:attributes) { { email: "invited-user@example.com" } }

      it "builds the correct request" do
        subject.add_collaborator(account_id, domain_id, attributes)

        expect(WebMock).to have_requested(:post, "https://api.dnsimple.test/v2/#{account_id}/domains/#{domain_id}/collaborators")
            .with(body: attributes)
            .with(headers: { 'Accept' => 'application/json' })
      end

      it "returns the contact" do
        response = subject.add_collaborator(account_id, domain_id, attributes)
        expect(response).to be_a(Dnsimple::Response)

        result = response.data
        expect(result).to be_a(Dnsimple::Struct::Collaborator)
        expect(result.id).to          be_a(Integer)
        expect(result.user_id).to     be(nil)
        expect(result.accepted_at).to be(nil)
        expect(result.user_email).to  eq(attributes.fetch(:email))
        expect(result.invitation).to  be(true)
      end
    end
  end

  describe "#remove_collaborator" do
    let(:account_id)      { 1010 }
    let(:domain_id)       { "example.com" }
    let(:collaborator_id) { 100 }

    before do
      stub_request(:delete, %r{/v2/#{account_id}/domains/#{domain_id}/collaborators/.+$})
          .to_return(read_http_fixture("removeCollaborator/success.http"))
    end

    it "builds the correct request" do
      subject.remove_collaborator(account_id, domain_id, collaborator_id)

      expect(WebMock).to have_requested(:delete, "https://api.dnsimple.test/v2/#{account_id}/domains/#{domain_id}/collaborators/#{collaborator_id}")
          .with(headers: { 'Accept' => 'application/json' })
    end

    it "returns nothing" do
      response = subject.remove_collaborator(account_id, domain_id, collaborator_id)
      expect(response).to be_a(Dnsimple::Response)

      result = response.data
      expect(result).to be_nil
    end

    context "when the collaborator does not exist" do
      it "raises NotFoundError" do
        stub_request(:delete, %r{/v2})
            .to_return(read_http_fixture("notfound-collaborator.http"))

        expect {
          subject.remove_collaborator(account_id, domain_id, collaborator_id)
        }.to raise_error(Dnsimple::NotFoundError)
      end
    end
  end

end
