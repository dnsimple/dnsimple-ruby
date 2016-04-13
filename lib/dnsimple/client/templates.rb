module Dnsimple
  class Client
    module Templates

      # Lists the templates in the account.
      #
      # @see https://developer.dnsimple.com/v2/templates/#list
      #
      # @example List the templates for account 1010:
      #   client.templates.list_templates(1010, "example.com")
      #
      # @param  [Fixnum] account_id the account ID
      # @param  [Hash] options
      # @return [Dnsimple::PaginatedResponse<Struct::Template>]
      #
      # @raise  [RequestError] When the request fails.
      def templates(account_id, options = {})
        endpoint = Client.versioned("/%s/templates" % [account_id])
        response = client.get(endpoint, options)

        Dnsimple::PaginatedResponse.new(response, response["data"].map { |r| Struct::Template.new(r) })
      end
      alias list templates
      alias list_templates templates

    end
  end
end
