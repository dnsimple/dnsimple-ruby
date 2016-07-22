module Dnsimple
  class Client
    module DomainServices

      # Lists the one-click services applied to the domain.
      #
      # @see https://developer.dnsimple.com/v2/services/domains/#applied
      #
      # @example List applied one-click services for example.com:
      #   client.domain_services.applied_services(1010, "example.com")
      #
      # @example List applied one-click services for example.com, provide a specific page:
      #   client.services.list_services(1010, "example.com", page: 2)
      #
      # @example List applied one-click services for example.com, provide a sorting policy:
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
      # @param  [Fixnum] account_id the account ID
      # @param  [#to_s] domain_name the domain name
      # @param  [#to_s] service_name the service name (or ID)
      # @param  [Hash] settings optional settings to apply the one-click service
      # @param  [Hash] options
      # @return [Dnsimple::Response<nil>]
      #
      # @raise  [RequestError] When the request fails.
      def apply_service(account_id, domain_name, service_name, settings = {}, options = {})
        endpoint = Client.versioned("/%s/domains/%s/services/%s" % [account_id, domain_name, service_name])
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
      # @param  [Fixnum] account_id the account ID
      # @param  [#to_s] domain_name the domain name
      # @param  [#to_s] service_name the service name (or ID)
      # @param  [Hash] options
      # @return [Dnsimple::Response<nil>]
      #
      # @raise  [RequestError] When the request fails.
      def unapply_service(account_id, domain_name, service_name, options = {})
        endpoint = Client.versioned("/%s/domains/%s/services/%s" % [account_id, domain_name, service_name])
        response = client.delete(endpoint, options)

        Dnsimple::Response.new(response, nil)
      end

    end
  end
end
