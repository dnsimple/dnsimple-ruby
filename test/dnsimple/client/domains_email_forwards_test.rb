# frozen_string_literal: true

require "test_helper"

describe Dnsimple::Client, ".domains" do

  let(:subject) { Dnsimple::Client.new(base_url: "https://api.dnsimple.test", access_token: "a1b2c3").domains }


  describe "#email_forwards" do
    let(:account_id) { 1010 }
    let(:domain_id) { "example.com" }

    before do
      stub_request(:get, %r{/v2/#{account_id}/domains/#{domain_id}/email_forwards})
          .to_return(read_http_fixture("listEmailForwards/success.http"))
    end

    it "builds the correct request" do
      subject.email_forwards(account_id, domain_id)

      assert_requested(:get, "https://api.dnsimple.test/v2/#{account_id}/domains/#{domain_id}/email_forwards",
                       headers: { "Accept" => "application/json" })
    end

    it "supports pagination" do
      subject.email_forwards(account_id, domain_id, page: 2)

      assert_requested(:get, "https://api.dnsimple.test/v2/#{account_id}/domains/#{domain_id}/email_forwards?page=2")
    end

    it "supports extra request options" do
      subject.email_forwards(account_id, domain_id, query: { foo: "bar" })

      assert_requested(:get, "https://api.dnsimple.test/v2/#{account_id}/domains/#{domain_id}/email_forwards?foo=bar")
    end

    it "supports sorting" do
      subject.email_forwards(account_id, domain_id, sort: "id:asc,from:desc")

      assert_requested(:get, "https://api.dnsimple.test/v2/#{account_id}/domains/#{domain_id}/email_forwards?sort=id:asc,from:desc")
    end

    it "returns the email forwards" do
      response = subject.email_forwards(account_id, domain_id)

      _(response).must_be_kind_of(Dnsimple::PaginatedResponse)
      _(response.data).must_be_kind_of(Array)
      _(response.data.size).must_equal(1)

      _(response.data[0].id).must_equal(24809)
      _(response.data[0].domain_id).must_equal(235146)
      _(response.data[0].alias_email).must_equal(".*@a-domain.com")
      _(response.data[0].destination_email).must_equal("jane.smith@example.com")
      _(response.data[0].active).must_equal(true)
    end

    it "exposes the pagination information" do
      response = subject.email_forwards(account_id, domain_id)

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
          subject.email_forwards(account_id, domain_id)
        }.must_raise(Dnsimple::NotFoundError)
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
      mock = Minitest::Mock.new
      mock.expect(:call, nil, [:email_forwards, account_id, domain_id, { foo: "bar" }])
      subject.stub(:paginate, mock) do
        subject.all_email_forwards(account_id, domain_id, { foo: "bar" })
      end
      mock.verify
    end

    it "supports sorting" do
      subject.all_email_forwards(account_id, domain_id, sort: "id:asc,from:desc")

      assert_requested(:get, "https://api.dnsimple.test/v2/#{account_id}/domains/#{domain_id}/email_forwards?page=1&per_page=100&sort=id:asc,from:desc")
    end
  end

  describe "#create_email_forward" do
    let(:account_id) { 1010 }
    let(:attributes) { { alias_name: "jim", destination_email: "jim@another.com" } }
    let(:domain_id) { "example.com" }

    before do
      stub_request(:post, %r{/v2/#{account_id}/domains/#{domain_id}/email_forwards$})
          .to_return(read_http_fixture("createEmailForward/created.http"))
    end


    it "builds the correct request" do
      subject.create_email_forward(account_id, domain_id, attributes)

      assert_requested(:post, "https://api.dnsimple.test/v2/#{account_id}/domains/#{domain_id}/email_forwards",
                       body: attributes,
                       headers: { "Accept" => "application/json" })
    end

    it "returns the email forward" do
      response = subject.create_email_forward(account_id, domain_id, attributes)
      _(response).must_be_kind_of(Dnsimple::Response)

      result = response.data
      _(result).must_be_kind_of(Dnsimple::Struct::EmailForward)
      _(result.id).must_be_kind_of(Integer)
    end
  end

  describe "#email_forward" do
    let(:account_id) { 1010 }
    let(:domain_id) { "example.com" }
    let(:email_forward_id) { 41872 }

    before do
      stub_request(:get, %r{/v2/#{account_id}/domains/#{domain_id}/email_forwards.+$})
          .to_return(read_http_fixture("getEmailForward/success.http"))
    end

    it "builds the correct request" do
      subject.email_forward(account_id, domain_id, email_forward_id)

      assert_requested(:get, "https://api.dnsimple.test/v2/#{account_id}/domains/#{domain_id}/email_forwards/#{email_forward_id}",
                       headers: { "Accept" => "application/json" })
    end

    it "returns the email forward" do
      response = subject.email_forward(account_id, domain_id, email_forward_id)
      _(response).must_be_kind_of(Dnsimple::Response)

      result = response.data
      _(result).must_be_kind_of(Dnsimple::Struct::EmailForward)
      _(result.id).must_equal(41872)
      _(result.domain_id).must_equal(235146)
      _(result.alias_email).must_equal("example@dnsimple.xyz")
      _(result.destination_email).must_equal("example@example.com")
      _(result.created_at).must_equal("2021-01-25T13:54:40Z")
      _(result.updated_at).must_equal("2021-01-25T13:54:40Z")
    end

    describe "when the email forward does not exist" do
      it "raises NotFoundError" do
        stub_request(:get, %r{/v2})
            .to_return(read_http_fixture("notfound-emailforward.http"))

        _ {
          subject.email_forward(account_id, domain_id, email_forward_id)
        }.must_raise(Dnsimple::NotFoundError)
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

      assert_requested(:delete, "https://api.dnsimple.test/v2/#{account_id}/domains/#{domain_id}/email_forwards/#{email_forward_id}",
                       headers: { "Accept" => "application/json" })
    end

    it "returns nothing" do
      response = subject.delete_email_forward(account_id, domain_id, email_forward_id)
      _(response).must_be_kind_of(Dnsimple::Response)

      result = response.data
      _(result).must_be_nil
    end

    describe "when the email forward does not exist" do
      it "raises NotFoundError" do
        stub_request(:delete, %r{/v2})
            .to_return(read_http_fixture("notfound-emailforward.http"))

        _ {
          subject.delete_email_forward(account_id, domain_id, email_forward_id)
        }.must_raise(Dnsimple::NotFoundError)
      end
    end
  end

end
