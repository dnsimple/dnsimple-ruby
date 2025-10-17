# frozen_string_literal: true

module Dnsimple
  class Client
    module TemplatesDomains
      # Applies a template to the domain.
      #
      # @see https://developer.dnsimple.com/v2/templates/domains/#apply
      #
      # @example Apply template 5401 for example.com in account 1010:
      #   client.templates.apply_template(1010, 5401, "example.com")
      #
      # @param  [Integer] account_id The account ID
      # @param  [#to_s] template_id The template ID
      # @param  [#to_s] domain_id The Domain ID or name
      # @param  [Hash] options
      # @return [Dnsimple::Response<nil>]
      #
      # @raise  [Dnsimple::NotFoundError]
      # @raise  [Dnsimple::RequestError]
      def apply_template(account_id, template_id, domain_id, options = {})
        endpoint = Client.versioned("/%s/domains/%s/templates/%s" % [account_id, domain_id, template_id])
        response = client.post(endpoint, options)

        Dnsimple::Response.new(response, nil)
      end
    end
  end
end
