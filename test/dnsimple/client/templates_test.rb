# frozen_string_literal: true

require "test_helper"

class TemplatesTest < Minitest::Test
  def setup
    @subject = Dnsimple::Client.new(base_url: "https://api.dnsimple.test", access_token: "a1b2c3").templates
    @account_id = 1010
  end

  def test_list_templates_builds_correct_request
    stub_request(:get, %r{/v2/#{@account_id}/templates})
        .to_return(read_http_fixture("listTemplates/success.http"))

    @subject.list_templates(@account_id)

    assert_requested(:get, "https://api.dnsimple.test/v2/#{@account_id}/templates",
                     headers: { "Accept" => "application/json" })
  end

  def test_list_templates_supports_pagination
    stub_request(:get, %r{/v2/#{@account_id}/templates})
        .to_return(read_http_fixture("listTemplates/success.http"))

    @subject.templates(@account_id, page: 2)

    assert_requested(:get, "https://api.dnsimple.test/v2/#{@account_id}/templates?page=2")
  end

  def test_list_templates_supports_extra_request_options
    stub_request(:get, %r{/v2/#{@account_id}/templates})
        .to_return(read_http_fixture("listTemplates/success.http"))

    @subject.templates(@account_id, query: { foo: "bar" })

    assert_requested(:get, "https://api.dnsimple.test/v2/#{@account_id}/templates?foo=bar")
  end

  def test_list_templates_supports_sorting
    stub_request(:get, %r{/v2/#{@account_id}/templates})
        .to_return(read_http_fixture("listTemplates/success.http"))

    @subject.templates(@account_id, sort: "short_name:desc")

    assert_requested(:get, "https://api.dnsimple.test/v2/#{@account_id}/templates?sort=short_name:desc")
  end

  def test_list_templates_returns_the_list_of_templates
    stub_request(:get, %r{/v2/#{@account_id}/templates})
        .to_return(read_http_fixture("listTemplates/success.http"))

    response = @subject.list_templates(@account_id)

    assert_kind_of(Dnsimple::CollectionResponse, response)

    response.data.each do |result|
      assert_kind_of(Dnsimple::Struct::Template, result)
      assert_kind_of(Numeric, result.id)
      assert_kind_of(Numeric, result.account_id)
      assert_kind_of(String, result.name)
      assert_kind_of(String, result.sid)
      assert_kind_of(String, result.description)
    end
  end

  def test_all_templates_delegates_to_paginate
    stub_request(:get, %r{/v2/#{@account_id}/templates})
        .to_return(read_http_fixture("listTemplates/success.http"))

    mock = Minitest::Mock.new
    mock.expect(:call, nil, [:templates, @account_id, { foo: "bar" }])
    @subject.stub(:paginate, mock) do
      @subject.all_templates(@account_id, { foo: "bar" })
    end
    mock.verify
  end

  def test_all_templates_supports_sorting
    stub_request(:get, %r{/v2/#{@account_id}/templates})
        .to_return(read_http_fixture("listTemplates/success.http"))

    @subject.all_templates(@account_id, sort: "short_name:desc")

    assert_requested(:get, "https://api.dnsimple.test/v2/#{@account_id}/templates?page=1&per_page=100&sort=short_name:desc")
  end

  def test_create_template_builds_correct_request
    stub_request(:post, %r{/v2/#{@account_id}/templates$})
        .to_return(read_http_fixture("createTemplate/created.http"))

    attributes = { name: "Beta", short_name: "beta", description: "A beta template." }
    @subject.create_template(@account_id, attributes)

    assert_requested(:post, "https://api.dnsimple.test/v2/#{@account_id}/templates",
                     headers: { "Accept" => "application/json" })
  end

  def test_create_template_returns_the_template
    stub_request(:post, %r{/v2/#{@account_id}/templates$})
        .to_return(read_http_fixture("createTemplate/created.http"))

    attributes = { name: "Beta", short_name: "beta", description: "A beta template." }
    response = @subject.create_template(@account_id, attributes)

    assert_kind_of(Dnsimple::Response, response)

    template = response.data

    assert_kind_of(Dnsimple::Struct::Template, template)
    assert_equal(1, template.id)
    assert_equal(1010, template.account_id)
    assert_equal("Beta", template.name)
    assert_equal("beta", template.sid)
    assert_equal("A beta template.", template.description)
  end

  def test_template_builds_correct_request
    stub_request(:get, %r{/v2/#{@account_id}/templates/1$})
        .to_return(read_http_fixture("getTemplate/success.http"))

    template_id = 1
    @subject.template(@account_id, template_id)

    assert_requested(:get, "https://api.dnsimple.test/v2/#{@account_id}/templates/#{template_id}",
                     headers: { "Accept" => "application/json" })
  end

  def test_template_returns_the_template
    stub_request(:get, %r{/v2/#{@account_id}/templates/1$})
        .to_return(read_http_fixture("getTemplate/success.http"))

    template_id = 1
    response = @subject.template(@account_id, template_id)

    assert_kind_of(Dnsimple::Response, response)

    template = response.data

    assert_kind_of(Dnsimple::Struct::Template, template)
    assert_equal(1, template.id)
    assert_equal(1010, template.account_id)
    assert_equal("Alpha", template.name)
    assert_equal("alpha", template.sid)
    assert_equal("An alpha template.", template.description)
  end

  def test_update_template_builds_correct_request
    stub_request(:patch, %r{/v2/#{@account_id}/templates/1$})
        .to_return(read_http_fixture("updateTemplate/success.http"))

    attributes = { name: "Alpha", short_name: "alpha", description: "An alpha template." }
    template_id = 1
    @subject.update_template(@account_id, template_id, attributes)

    assert_requested(:patch, "https://api.dnsimple.test/v2/#{@account_id}/templates/#{template_id}",
                     headers: { "Accept" => "application/json" })
  end

  def test_update_template_returns_the_template
    stub_request(:patch, %r{/v2/#{@account_id}/templates/1$})
        .to_return(read_http_fixture("updateTemplate/success.http"))

    attributes = { name: "Alpha", short_name: "alpha", description: "An alpha template." }
    template_id = 1
    response = @subject.update_template(@account_id, template_id, attributes)

    assert_kind_of(Dnsimple::Response, response)

    template = response.data

    assert_kind_of(Dnsimple::Struct::Template, template)
    assert_equal(1, template.id)
    assert_equal(1010, template.account_id)
    assert_equal("Alpha", template.name)
    assert_equal("alpha", template.sid)
    assert_equal("An alpha template.", template.description)
  end

  def test_delete_template_builds_correct_request
    stub_request(:delete, %r{/v2/#{@account_id}/templates/5410$})
        .to_return(read_http_fixture("deleteTemplate/success.http"))

    template_id = 5410
    @subject.delete_template(@account_id, template_id)

    assert_requested(:delete, "https://api.dnsimple.test/v2/#{@account_id}/templates/#{template_id}",
                     headers: { "Accept" => "application/json" })
  end

  def test_delete_template_returns_nil
    stub_request(:delete, %r{/v2/#{@account_id}/templates/5410$})
        .to_return(read_http_fixture("deleteTemplate/success.http"))

    template_id = 5410
    response = @subject.delete_template(@account_id, template_id)

    assert_kind_of(Dnsimple::Response, response)
    assert_nil(response.data)
  end

  def test_apply_template_builds_correct_request
    stub_request(:post, %r{/v2/#{@account_id}/domains/example.com/templates/5410$})
        .to_return(read_http_fixture("applyTemplate/success.http"))

    template_id = 5410
    domain_id = "example.com"
    @subject.apply_template(@account_id, template_id, domain_id)

    assert_requested(:post, "https://api.dnsimple.test/v2/#{@account_id}/domains/#{domain_id}/templates/#{template_id}",
                     headers: { "Accept" => "application/json" })
  end

  def test_apply_template_returns_nil
    stub_request(:post, %r{/v2/#{@account_id}/domains/example.com/templates/5410$})
        .to_return(read_http_fixture("applyTemplate/success.http"))

    template_id = 5410
    domain_id = "example.com"
    response = @subject.apply_template(@account_id, template_id, domain_id)

    assert_kind_of(Dnsimple::Response, response)
    assert_nil(response.data)
  end
end
