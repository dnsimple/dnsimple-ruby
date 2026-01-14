# frozen_string_literal: true

module Dnsimple
  class Client
    module ServicesDomains
      # Lists the one-click services applied to the domain.
      #
      # @see https://developer.dnsimple.com/v2/services/domains/#applied
      #
      # @example List applied one-click services for example.com:
      #   client.service.applied_services(1010, "example.com")
      #
      # @example List applied one-click services for example.com, provide a specific page:
      #   client.services.applied_services(1010, "example.com", page: 2)
      #
      # @example List applied one-click services for example.com, provide a sorting policy:
      #   client.services.applied_services(1010, "example.com", sort: "short_name:asc")
      #
      # @param  account_id [Integer] the account ID
      # @param  domain_id [#to_s] the domain name
      # @param  options [Hash] the filtering and sorting options
      # @option options [Integer] :page current page (pagination)
      # @option options [Integer] :per_page number of entries to return (pagination)
      # @option options [String] :sort sorting policy
      # @return [Dnsimple::PaginatedResponse<Dnsimple::Struct::Service>]
      #
      # @raise  [RequestError] When the request fails.
      def applied_services(account_id, domain_id, options = {})
        endpoint = Client.versioned("/%s/domains/%s/services" % [account_id, domain_id])
        response = client.get(endpoint, Options::ListOptions.new(options))

        Dnsimple::PaginatedResponse.new(response, response["data"].map { |r| Struct::Service.new(r) })
      end

      # Apply a given one-click service to the domain.
      #
      # @see https://developer.dnsimple.com/v2/services/domains/#apply
      #
      # @example Apply one-click service service1 to example.com:
      #   client.domain_services.applied_services(1010, "example.com", "service1")
      #
      # @example Apply one-click service service1 to example.com, provide optional settings:
      #   client.domain_services.applied_services(1010, "example.com", "service1", app: "foo")
      #
      # @param  account_id [Integer] the account ID
      # @param  service_id [#to_s] the service name (or ID)
      # @param  domain_id [#to_s] the domain name
      # @param  settings [Hash] optional settings to apply the one-click service
      # @param  options [Hash]
      # @return [Dnsimple::Response<nil>]
      #
      # @raise  [RequestError] When the request fails.
      def apply_service(account_id, service_id, domain_id, settings = {}, options = {})
        endpoint = Client.versioned("/%s/domains/%s/services/%s" % [account_id, domain_id, service_id])
        response = client.post(endpoint, settings, options)

        Dnsimple::Response.new(response, nil)
      end

      # Unapply a given one-click service from the domain.
      #
      # @see https://developer.dnsimple.com/v2/services/domains/#unapply
      #
      # @example Unapply one-click service service1 from example.com:
      #   client.domain_services.applied_services(1010, "example.com", "service1")
      #
      # @param  account_id [Integer] the account ID
      # @param  service_id [#to_s] the service name (or ID)
      # @param  domain_id [#to_s] the domain name
      # @param  options [Hash]
      # @return [Dnsimple::Response<nil>]
      #
      # @raise  [RequestError] When the request fails.
      def unapply_service(account_id, service_id, domain_id, options = {})
        endpoint = Client.versioned("/%s/domains/%s/services/%s" % [account_id, domain_id, service_id])
        response = client.delete(endpoint, options)

        Dnsimple::Response.new(response, nil)
      end
    end
  end
end
