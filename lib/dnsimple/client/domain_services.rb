module Dnsimple
  class Client
    module DomainServices

      # Lists the one-click services applied to the domain.
      #
      # @see https://developer.dnsimple.com/v2/services/domains/#applied
      #
      # @example List one-click applied services for example.com:
      #   client.domain_services.applied_services(1010, "example.com")
      #
      # @example List one-click applied services for example.com, provide a specific page:
      #   client.services.list_services(1010, "example.com", page: 2)
      #
      # @example List one-click applied services for example.com, provide a sorting policy:
      #   client.services.list_services(1010, "example.com", sort: "short_name:asc")
      #
      # @param  [Fixnum] account_id the account ID
      # @param  [#to_s] domain_name the domain name
      # @param  [Hash] options the filtering and sorting options
      # @option options [Integer] :page current page (pagination)
      # @option options [Integer] :per_page number of entries to return (pagination)
      # @option options [String] :sort sorting policy
      # @return [Dnsimple::PaginatedResponse<Dnsimple::Struct::Service>]
      #
      # @raise  [RequestError] When the request fails.
      def applied_services(account_id, domain_name, options = {})
        endpoint = Client.versioned("/%s/domains/%s/services" % [account_id, domain_name])
        response = client.get(endpoint, Options::ListOptions.new(options))

        Dnsimple::PaginatedResponse.new(response, response["data"].map { |r| Struct::Service.new(r) })
      end
    end
  end
end
