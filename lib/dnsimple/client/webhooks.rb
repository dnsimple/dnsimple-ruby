module Dnsimple
  class Client
    module Webhooks

      # Lists the webhooks in the account.
      #
      # @see https://developer.dnsimple.com/v2/webhooks/#list
      # @see #all_webhooks
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

      # Lists ALL the webhooks in the account.
      #
      # This is equal to {#webhooks}.
      # We have implemented both methods to have a consistent design with other
      # resources that implements pagination.
      #
      # @see https://developer.dnsimple.com/v2/webhooks/#list
      # @see #webhooks
      #
      # @param  [Fixnum] account_id the account ID
      # @param  [Hash] options the filtering and sorting option
      # @return [Dnsimple::CollectionResponse<Dnsimple::Struct::Webhook>]
      #
      # @raise  [Dnsimple::RequestError]
      def all_webhooks(account_id, options = {})
        webhooks(account_id, options)
      end
      alias :all :all_webhooks

    end
  end
end
