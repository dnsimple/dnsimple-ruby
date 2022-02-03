# frozen_string_literal: true

require 'spec_helper'

describe Dnsimple::Client, ".templates" do

  subject { described_class.new(base_url: "https://api.dnsimple.test", access_token: "a1b2c3").templates }


  describe "#list_templates" do
    let(:account_id) { 1010 }

    before do
      stub_request(:get, %r{/v2/#{account_id}/templates})
          .to_return(read_http_fixture("listTemplates/success.http"))
    end

    it "builds the correct request" do
      subject.list_templates(account_id)

      expect(WebMock).to have_requested(:get, "https://api.dnsimple.test/v2/#{account_id}/templates")
          .with(headers: { "Accept" => "application/json" })
    end

    it "supports pagination" do
      subject.templates(account_id, page: 2)

      expect(WebMock).to have_requested(:get, "https://api.dnsimple.test/v2/#{account_id}/templates?page=2")
    end

    it "supports extra request options" do
      subject.templates(account_id, query: { foo: "bar" })

      expect(WebMock).to have_requested(:get, "https://api.dnsimple.test/v2/#{account_id}/templates?foo=bar")
    end

    it "supports sorting" do
      subject.templates(account_id, sort: "short_name:desc")

      expect(WebMock).to have_requested(:get, "https://api.dnsimple.test/v2/#{account_id}/templates?sort=short_name:desc")
    end

    it "returns the list of templates" do
      response = subject.list_templates(account_id)
      expect(response).to be_a(Dnsimple::CollectionResponse)

      response.data.each do |result|
        expect(result).to be_a(Dnsimple::Struct::Template)
        expect(result.id).to be_a(Numeric)
        expect(result.account_id).to be_a(Numeric)
        expect(result.name).to be_a(String)
        expect(result.sid).to be_a(String)
        expect(result.description).to be_a(String)
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
      expect(subject).to receive(:paginate).with(:templates, account_id, { foo: "bar" })
      subject.all_templates(account_id, { foo: "bar" })
    end

    it "supports sorting" do
      subject.all_templates(account_id, sort: "short_name:desc")

      expect(WebMock).to have_requested(:get, "https://api.dnsimple.test/v2/#{account_id}/templates?page=1&per_page=100&sort=short_name:desc")
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

      expect(WebMock).to have_requested(:post, "https://api.dnsimple.test/v2/#{account_id}/templates")
          .with(headers: { "Accept" => "application/json" })
    end

    it "returns the list of templates" do
      response = subject.create_template(account_id, attributes)
      expect(response).to be_a(Dnsimple::Response)

      template = response.data
      expect(template).to be_a(Dnsimple::Struct::Template)
      expect(template.id).to eq(1)
      expect(template.account_id).to eq(1010)
      expect(template.name).to eq("Beta")
      expect(template.sid).to eq("beta")
      expect(template.description).to eq("A beta template.")
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

      expect(WebMock).to have_requested(:get, "https://api.dnsimple.test/v2/#{account_id}/templates/#{template_id}")
          .with(headers: { "Accept" => "application/json" })
    end

    it "returns the list of templates" do
      response = subject.template(account_id, template_id)
      expect(response).to be_a(Dnsimple::Response)

      template = response.data
      expect(template).to be_a(Dnsimple::Struct::Template)
      expect(template.id).to eq(1)
      expect(template.account_id).to eq(1010)
      expect(template.name).to eq("Alpha")
      expect(template.sid).to eq("alpha")
      expect(template.description).to eq("An alpha template.")
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

      expect(WebMock).to have_requested(:patch, "https://api.dnsimple.test/v2/#{account_id}/templates/#{template_id}")
          .with(headers: { "Accept" => "application/json" })
    end

    it "returns the list of templates" do
      response = subject.update_template(account_id, template_id, attributes)
      expect(response).to be_a(Dnsimple::Response)

      template = response.data
      expect(template).to be_a(Dnsimple::Struct::Template)
      expect(template.id).to eq(1)
      expect(template.account_id).to eq(1010)
      expect(template.name).to eq("Alpha")
      expect(template.sid).to eq("alpha")
      expect(template.description).to eq("An alpha template.")
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

      expect(WebMock).to have_requested(:delete, "https://api.dnsimple.test/v2/#{account_id}/templates/#{template_id}")
          .with(headers: { "Accept" => "application/json" })
    end

    it "returns nil" do
      response = subject.delete_template(account_id, template_id)
      expect(response).to be_a(Dnsimple::Response)
      expect(response.data).to be_nil
    end
  end

  describe "#apply_template" do
    let(:account_id)  { 1010 }
    let(:template_id) { 5410 }
    let(:domain_id)   { 'example.com' }

    before do
      stub_request(:post, %r{/v2/#{account_id}/domains/#{domain_id}/templates/#{template_id}$})
          .to_return(read_http_fixture("applyTemplate/success.http"))
    end

    it "builds the correct request" do
      subject.apply_template(account_id, template_id, domain_id)

      expect(WebMock).to have_requested(:post, "https://api.dnsimple.test/v2/#{account_id}/domains/#{domain_id}/templates/#{template_id}")
          .with(headers: { "Accept" => "application/json" })
    end

    it "returns nil" do
      response = subject.apply_template(account_id, template_id, domain_id)
      expect(response).to be_a(Dnsimple::Response)
      expect(response.data).to be_nil
    end
  end

end
