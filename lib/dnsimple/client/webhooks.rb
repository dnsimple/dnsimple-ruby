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
      # @param  [Fixnum] account_id the account ID
      # @param  [Hash] options the filtering and sorting option
      # @return [Dnsimple::CollectionResponse<Dnsimple::Struct::Webhook>]
      #
      # @raise  [Dnsimple::RequestError]
      def webhooks(account_id, options = {})
        response = client.get(Client.versioned("/%s/webhooks" % [account_id]), options)

        Dnsimple::CollectionResponse.new(response, response["data"].map { |r| Struct::Webhook.new(r) })
      end
      alias :list :webhooks
      alias :list_webhooks :webhooks

      # Creates a webhook in the account.
      #
      # @see https://developer.dnsimple.com/v2/webhooks/#create
      #
      # @param  [Fixnum] account_id the account ID
      # @param  [Hash] attributes
      # @param  [Hash] options
      # @return [Dnsimple::Response<Dnsimple::Struct::Webhook>]
      #
      # @raise  [Dnsimple::RequestError]
      def create_webhook(account_id, attributes = {}, options = {})
        Extra.validate_mandatory_attributes(attributes, [:url])
        options  = options.merge(attributes)
        response = client.post(Client.versioned("/%s/webhooks" % [account_id]), options)

        Dnsimple::Response.new(response, Struct::Webhook.new(response["data"]))
      end
      alias :create :create_webhook

      # Gets a webhook from the account.
      #
      # @see https://developer.dnsimple.com/v2/webhooks/#get
      #
      # @param  [Fixnum] account_id the account ID
      # @param  [#to_s] webhook_id The webhook ID.
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
      # @param  [Fixnum] account_id the account ID
      # @param  [#to_s] webhook_id The webhook ID.
      # @param  [Hash] options
      # @return [Dnsimple::Response<nil>]
      #
      # @raise  [Dnsimple::NotFoundError]
      # @raise  [Dnsimple::RequestError]
      def delete_webhook(account_id, webhook_id, options = {})
        response = client.delete(Client.versioned("/%s/webhooks/%s" % [account_id, webhook_id]), options)

        Dnsimple::Response.new(response, nil)
      end
      alias :delete :delete_webhook

    end
  end
end
