# frozen_string_literal: true

require "test_helper"

describe Dnsimple::Client, ".templates" do

  let(:subject) { Dnsimple::Client.new(base_url: "https://api.dnsimple.test", access_token: "a1b2c3").templates }


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
