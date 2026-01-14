# frozen_string_literal: true

require "test_helper"

class TemplatesDomainsTest < Minitest::Test

  def setup
    @subject = Dnsimple::Client.new(base_url: "https://api.dnsimple.test", access_token: "a1b2c3").templates
    @account_id = 1010
    @template_id = 5410
    @domain_id = "example.com"
  end

  def test_apply_template_builds_correct_request
    stub_request(:post, %r{/v2/#{@account_id}/domains/#{@domain_id}/templates/#{@template_id}$})
        .to_return(read_http_fixture("applyTemplate/success.http"))

    @subject.apply_template(@account_id, @template_id, @domain_id)

    assert_requested(:post, "https://api.dnsimple.test/v2/#{@account_id}/domains/#{@domain_id}/templates/#{@template_id}",
                     headers: { "Accept" => "application/json" })
  end

  def test_apply_template_returns_nil
    stub_request(:post, %r{/v2/#{@account_id}/domains/#{@domain_id}/templates/#{@template_id}$})
        .to_return(read_http_fixture("applyTemplate/success.http"))

    response = @subject.apply_template(@account_id, @template_id, @domain_id)
    assert_kind_of(Dnsimple::Response, response)
    assert_nil(response.data)
  end

end
