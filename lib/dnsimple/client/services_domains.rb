module Dnsimple
  class Client
    module ServicesDomains

      # Lists the services applied to a domain.
      #
      # @see http://developer.dnsimple.com/v1/services/#applied
      #
      # @param  [#to_s] domain The domain id or domain name.
      # @return [Array<Struct::Service>]
      #
      # @raise  [NotFoundError]
      # @raise  [RequestError] When the request fails.
      def applied(domain, options = {})
        response = client.get(Client.versioned("domains/#{domain}/applied_services"), options)

        response.map { |r| Struct::Service.new(r["service"]) }
      end

      # Lists the services not applied to a domain.
      #
      # @see http://developer.dnsimple.com/v1/services/#available
      #
      # @param  [#to_s] domain The domain id or domain name.
      # @return [Array<Struct::Service>]
      #
      # @raise  [NotFoundError]
      # @raise  [RequestError] When the request fails.
      def available(domain, options = {})
        response = client.get(Client.versioned("domains/#{domain}/available_services"), options)

        response.map { |r| Struct::Service.new(r["service"]) }
      end

      # Applies a service to a domain.
      #
      # @see http://developer.dnsimple.com/v1/services/#apply
      #
      # @param  [#to_s] domain The domain id or domain name.
      # @param  [Fixnum] service The service id.
      # @return [void]
      #
      # @raise  [NotFoundError]
      # @raise  [RequestError] When the request fails.
      def apply(domain, service, options = {})
        options  = Extra.deep_merge(options, { service: { id: service }})
        response = client.post(Client.versioned("domains/#{domain}/applied_services"), options)
        response.code == 200
      end

      # Un-applies a service from a domain.
      #
      # @see http://developer.dnsimple.com/v1/services/#unapply
      #
      # @param  [#to_s] domain The domain id or domain name.
      # @param  [Fixnum] service The service id.
      # @return [void]
      #
      # @raise  [NotFoundError]
      # @raise  [RequestError] When the request fails.
      def unapply(domain, service, options = {})
        response = client.delete(Client.versioned("domains/#{domain}/applied_services/#{service}"), options)
        response.code == 200
      end

    end
  end
end
