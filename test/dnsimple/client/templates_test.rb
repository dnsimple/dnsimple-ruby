# frozen_string_literal: true

require "test_helper"

describe Dnsimple::Client, ".templates" do

  let(:subject) { Dnsimple::Client.new(base_url: "https://api.dnsimple.test", access_token: "a1b2c3").templates }


  describe "#list_templates" do
    let(:account_id) { 1010 }

    before do
      stub_request(:get, %r{/v2/#{account_id}/templates})
          .to_return(read_http_fixture("listTemplates/success.http"))
    end

    it "builds the correct request" do
      subject.list_templates(account_id)

      assert_requested(:get, "https://api.dnsimple.test/v2/#{account_id}/templates",
                       headers: { "Accept" => "application/json" })
    end

    it "supports pagination" do
      subject.templates(account_id, page: 2)

      assert_requested(:get, "https://api.dnsimple.test/v2/#{account_id}/templates?page=2")
    end

    it "supports extra request options" do
      subject.templates(account_id, query: { foo: "bar" })

      assert_requested(:get, "https://api.dnsimple.test/v2/#{account_id}/templates?foo=bar")
    end

    it "supports sorting" do
      subject.templates(account_id, sort: "short_name:desc")

      assert_requested(:get, "https://api.dnsimple.test/v2/#{account_id}/templates?sort=short_name:desc")
    end

    it "returns the list of templates" do
      response = subject.list_templates(account_id)
      _(response).must_be_kind_of(Dnsimple::CollectionResponse)

      response.data.each do |result|
        _(result).must_be_kind_of(Dnsimple::Struct::Template)
        _(result.id).must_be_kind_of(Numeric)
        _(result.account_id).must_be_kind_of(Numeric)
        _(result.name).must_be_kind_of(String)
        _(result.sid).must_be_kind_of(String)
        _(result.description).must_be_kind_of(String)
      end
    end
  end

  describe "#all_templates" do
    before do
      stub_request(:get, %r{/v2/#{account_id}/templates})
          .to_return(read_http_fixture("listTemplates/success.http"))
    end

    let(:account_id) { 1010 }

    it "delegates to client.paginate" do
      mock = Minitest::Mock.new
      mock.expect(:call, nil, [:templates, account_id, { foo: "bar" }])
      subject.stub(:paginate, mock) do
        subject.all_templates(account_id, { foo: "bar" })
      end
      mock.verify
    end

    it "supports sorting" do
      subject.all_templates(account_id, sort: "short_name:desc")

      assert_requested(:get, "https://api.dnsimple.test/v2/#{account_id}/templates?page=1&per_page=100&sort=short_name:desc")
    end
  end

  describe "#create_template" do
    let(:account_id) { 1010 }
    let(:attributes) { { name: "Beta", short_name: "beta", description: "A beta template." } }

    before do
      stub_request(:post, %r{/v2/#{account_id}/templates$})
          .to_return(read_http_fixture("createTemplate/created.http"))
    end


    it "builds the correct request" do
      subject.create_template(account_id, attributes)

      assert_requested(:post, "https://api.dnsimple.test/v2/#{account_id}/templates",
                       headers: { "Accept" => "application/json" })
    end

    it "returns the list of templates" do
      response = subject.create_template(account_id, attributes)
      _(response).must_be_kind_of(Dnsimple::Response)

      template = response.data
      _(template).must_be_kind_of(Dnsimple::Struct::Template)
      _(template.id).must_equal(1)
      _(template.account_id).must_equal(1010)
      _(template.name).must_equal("Beta")
      _(template.sid).must_equal("beta")
      _(template.description).must_equal("A beta template.")
    end
  end

  describe "#template" do
    let(:account_id) { 1010 }
    let(:template_id) { 1 }

    before do
      stub_request(:get, %r{/v2/#{account_id}/templates/#{template_id}$})
          .to_return(read_http_fixture("getTemplate/success.http"))
    end

    it "builds the correct request" do
      subject.template(account_id, template_id)

      assert_requested(:get, "https://api.dnsimple.test/v2/#{account_id}/templates/#{template_id}",
                       headers: { "Accept" => "application/json" })
    end

    it "returns the list of templates" do
      response = subject.template(account_id, template_id)
      _(response).must_be_kind_of(Dnsimple::Response)

      template = response.data
      _(template).must_be_kind_of(Dnsimple::Struct::Template)
      _(template.id).must_equal(1)
      _(template.account_id).must_equal(1010)
      _(template.name).must_equal("Alpha")
      _(template.sid).must_equal("alpha")
      _(template.description).must_equal("An alpha template.")
    end
  end

  describe "#update_template" do
    let(:account_id) { 1010 }
    let(:attributes) { { name: "Alpha", short_name: "alpha", description: "An alpha template." } }
    let(:template_id) { 1 }

    before do
      stub_request(:patch, %r{/v2/#{account_id}/templates/#{template_id}$})
          .to_return(read_http_fixture("updateTemplate/success.http"))
    end


    it "builds the correct request" do
      subject.update_template(account_id, template_id, attributes)

      assert_requested(:patch, "https://api.dnsimple.test/v2/#{account_id}/templates/#{template_id}",
                       headers: { "Accept" => "application/json" })
    end

    it "returns the list of templates" do
      response = subject.update_template(account_id, template_id, attributes)
      _(response).must_be_kind_of(Dnsimple::Response)

      template = response.data
      _(template).must_be_kind_of(Dnsimple::Struct::Template)
      _(template.id).must_equal(1)
      _(template.account_id).must_equal(1010)
      _(template.name).must_equal("Alpha")
      _(template.sid).must_equal("alpha")
      _(template.description).must_equal("An alpha template.")
    end
  end

  describe "#delete_template" do
    let(:account_id) { 1010 }
    let(:template_id) { 5410 }

    before do
      stub_request(:delete, %r{/v2/#{account_id}/templates/#{template_id}$})
          .to_return(read_http_fixture("deleteTemplate/success.http"))
    end

    it "builds the correct request" do
      subject.delete_template(account_id, template_id)

      assert_requested(:delete, "https://api.dnsimple.test/v2/#{account_id}/templates/#{template_id}",
                       headers: { "Accept" => "application/json" })
    end

    it "returns nil" do
      response = subject.delete_template(account_id, template_id)
      _(response).must_be_kind_of(Dnsimple::Response)
      _(response.data).must_be_nil
    end
  end

  describe "#apply_template" do
    let(:account_id)  { 1010 }
    let(:template_id) { 5410 }
    let(:domain_id)   { "example.com" }

    before do
      stub_request(:post, %r{/v2/#{account_id}/domains/#{domain_id}/templates/#{template_id}$})
          .to_return(read_http_fixture("applyTemplate/success.http"))
    end

    it "builds the correct request" do
      subject.apply_template(account_id, template_id, domain_id)

      assert_requested(:post, "https://api.dnsimple.test/v2/#{account_id}/domains/#{domain_id}/templates/#{template_id}",
                       headers: { "Accept" => "application/json" })
    end

    it "returns nil" do
      response = subject.apply_template(account_id, template_id, domain_id)
      _(response).must_be_kind_of(Dnsimple::Response)
      _(response.data).must_be_nil
    end
  end

end
