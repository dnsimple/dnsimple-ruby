module Dnsimple
  class Client
    module Webhooks

      # Lists ALL the webhooks in the account.
      #
      # @see https://developer.dnsimple.com/v2/webhooks/#list
      #
      # @example List all webhooks
      #   client.webhooks.list(1010)
      #
      # @example List all webhooks, provide a specific page
      #   client.webhooks.list(1010, page: 2)
      #
      # @example List all webhooks, provide sorting policy
      #   client.webhooks.list(1010, sort: "id:asc")
      #
      # @param  [Integer] account_id the account ID
      # @param  [Hash] options the filtering and sorting options
      # @option options [Integer] :page current page (pagination)
      # @option options [Integer] :per_page number of entries to return (pagination)
      # @option options [String] :sort sorting policy
      # @return [Dnsimple::CollectionResponse<Dnsimple::Struct::Webhook>]
      #
      # @raise  [Dnsimple::RequestError]
      def webhooks(account_id, options = {})
        response = client.get(Client.versioned("/%s/webhooks" % [account_id]), Options::ListOptions.new(options))

        Dnsimple::CollectionResponse.new(response, response["data"].map { |r| Struct::Webhook.new(r) })
      end
      alias list_webhooks webhooks

      # Creates a webhook in the account.
      #
      # @see https://developer.dnsimple.com/v2/webhooks/#create
      #
      # @param  [Integer] account_id the account ID
      # @param  [Hash] attributes
      # @param  [Hash] options
      # @return [Dnsimple::Response<Dnsimple::Struct::Webhook>]
      #
      # @raise  [Dnsimple::RequestError]
      def create_webhook(account_id, attributes, options = {})
        Extra.validate_mandatory_attributes(attributes, [:url])
        response = client.post(Client.versioned("/%s/webhooks" % [account_id]), attributes, options)

        Dnsimple::Response.new(response, Struct::Webhook.new(response["data"]))
      end

      # Gets a webhook from the account.
      #
      # @see https://developer.dnsimple.com/v2/webhooks/#get
      #
      # @param  [Integer] account_id the account ID
      # @param  [#to_s] webhook_id The webhook ID
      # @param  [Hash] options
      # @return [Dnsimple::Response<Dnsimple::Struct::Webhook>]
      #
      # @raise  [Dnsimple::NotFoundError]
      # @raise  [Dnsimple::RequestError]
      def webhook(account_id, webhook_id, options = {})
        response = client.get(Client.versioned("/%s/webhooks/%s" % [account_id, webhook_id]), options)

        Dnsimple::Response.new(response, Struct::Webhook.new(response["data"]))
      end

      # Deletes a webook from the account.
      #
      # WARNING: this cannot be undone.
      #
      # @see https://developer.dnsimple.com/v2/webooks/#delete
      #
      # @param  [Integer] account_id the account ID
      # @param  [#to_s] webhook_id The webhook ID
      # @param  [Hash] options
      # @return [Dnsimple::Response<nil>]
      #
      # @raise  [Dnsimple::NotFoundError]
      # @raise  [Dnsimple::RequestError]
      def delete_webhook(account_id, webhook_id, options = {})
        response = client.delete(Client.versioned("/%s/webhooks/%s" % [account_id, webhook_id]), nil, options)

        Dnsimple::Response.new(response, nil)
      end

    end
  end
end
