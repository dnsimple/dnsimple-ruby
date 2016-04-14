module Dnsimple
  class Client
    module Templates

      # Lists the templates in the account.
      #
      # @see https://developer.dnsimple.com/v2/templates/#list
      #
      # @example List the templates for account 1010:
      #   client.templates.list_templates(1010)
      #
      # @param  [Fixnum] account_id the account ID
      # @param  [Hash] options
      # @return [Dnsimple::PaginatedResponse<Dnsimple::Struct::Template>]
      #
      # @raise  [RequestError] When the request fails.
      def templates(account_id, options = {})
        endpoint = Client.versioned("/%s/templates" % [account_id])
        response = client.get(endpoint, options)

        Dnsimple::PaginatedResponse.new(response, response["data"].map { |r| Struct::Template.new(r) })
      end
      alias list templates
      alias list_templates templates

      # Lists ALL the templates in the account.
      #
      # This method is similar to {#templates}, but instead of returning the results of a specific page
      # it iterates all the pages and returns the entire collection.
      #
      # Please use this method carefully, as fetching the entire collection will increase the number of
      # requests you send to the API server and you may eventually risk to hit the throttle limit.
      #
      # @example List all the templates for account 1010:
      #   client.all_templates.list_templates(1010)
      #
      # @see https://developer.dnsimple.com/v2/templates/#list
      # @see #templates
      #
      # @param  [Fixnum] account_id the account ID
      # @param  [Hash] options
      # @return [Dnsimple::PaginatedResponse<Dnsimple::Struct::Template>]
      #
      # @raise  [RequestError] When the request fails.
      def all_templates(account_id, options = {})
        paginate(:templates, account_id, options)
      end
      alias all all_templates

      # Creates a template in the account.
      #
      # @see https://developer.dnsimple.com/v2/templates/#create
      #
      # @example Creating a template:
      #   client.templates.create_template(1010, name: "Pi", short_name: "pi", description: "Pi template")
      #
      # @param  [Fixnum] account_id the account ID
      # @param  [Hash] attributes
      # @param  [Hash] options
      # @return [Dnsimple::Response<Dnsimple::Struct::Template>]
      #
      # @raise  [Dnsimple::RequestError]
      def create_template(account_id, attributes, options = {})
        endpoint = Client.versioned("/%s/templates" % [account_id])
        response = client.post(endpoint, attributes, options)

        Dnsimple::Response.new(response, Struct::Template.new(response["data"]))
      end

      # Gets the template with specified ID.
      #
      # @see https://developer.dnsimple.com/v2/templates/#get
      #
      # @example Get template 5401 in account 1010:
      #   client.templates.template(1010, 5401)
      #
      # @param  [Fixnum] account_id the account ID
      # @param  [Fixnum] template_id the template ID
      # @param  [Hash] options
      # @return [Dnsimple::Response<Dnsimple::Struct::Template>]
      #
      # @raise  [RequestError] When the request fails.
      def template(account_id, template_id, options = {})
        endpoint = Client.versioned("/%s/templates/%s" % [account_id, template_id])
        response = client.get(endpoint, options)

        Dnsimple::Response.new(response, Struct::Template.new(response["data"]))
      end

    end
  end
end
