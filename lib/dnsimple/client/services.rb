module Dnsimple
  class Client
    module Services

      # Lists the available one-click services.
      #
      # @see https://developer.dnsimple.com/v2/services/#list
      #
      # @example List one-click services:
      #   client.services.list_services
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
      alias list_services services

      # Lists ALL the available one-click services.
      #
      # This method is similar to {#services}, but instead of returning the results of a specific page
      # it iterates all the pages and returns the entire collection.
      #
      # Please use this method carefully, as fetching the entire collection will increase the number of
      # requests you send to the API server and you may eventually risk to hit the throttle limit.
      #
      # @example List all the one-click services:
      #   client.services.all_services
      #
      # @see https://developer.dnsimple.com/v2/services/#list
      # @see #services
      #
      # @param  [Hash] options
      # @return [Dnsimple::PaginatedResponse<Dnsimple::Struct::Service>]
      #
      # @raise  [RequestError] When the request fails.
      def all_services(options = {})
        paginate(:services, options)
      end

      # Gets the service with specified ID.
      #
      # @see https://developer.dnsimple.com/v2/services/#get
      #
      # @example Get service 43:
      #   client.services.service(43)
      #
      # @param  [#to_s] service_id The service ID
      # @param  [Hash] options
      # @return [Dnsimple::Response<Dnsimple::Struct::Service>]
      #
      # @raise  [RequestError] When the request fails.
      def service(service_id, options = {})
        endpoint = Client.versioned("/services/%s" % [service_id])
        response = client.get(endpoint, options)

        Dnsimple::Response.new(response, Struct::Service.new(response["data"]))
      end
    end
  end
end
