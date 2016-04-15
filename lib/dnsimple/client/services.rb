module Dnsimple
  class Client
    module Services

      # Lists the available one-click services.
      #
      # @see https://developer.dnsimple.com/v2/services/#list
      #
      # @example List all the one-click services:
      #   client.templates.list_services
      #
      # @param  [Hash] options
      # @return [Dnsimple::PaginatedResponse<Dnsimple::Struct::Service>]
      #
      # @raise  [RequestError] When the request fails.
      def services(options = {})
        endpoint = Client.versioned("/services")
        response = client.get(endpoint, options)

        Dnsimple::PaginatedResponse.new(response, response["data"].map { |r| Struct::Service.new(r) })
      end
      alias list services
      alias list_services services

    end
  end
end
