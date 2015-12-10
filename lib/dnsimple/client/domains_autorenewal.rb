module Dnsimple
  class Client
    module DomainsAutorenewal

      # Enables auto-renewal for a domain.
      #
      # @see http://developer.dnsimple.com/v1/registrar/auto-renewal/#enable
      #
      # @param  [#to_s] domain The domain id or domain name.
      # @return [Struct::Domain]
      #
      # @raise  [RequestError] When the request fails.
      def enable_auto_renewal(domain, options = {})
        response = client.post(Client.versioned("/domains/#{domain}/auto_renewal"), options)

        Struct::Domain.new(response["domain"])
      end

      # Disables auto-renewal for a domain.
      #
      # @see http://developer.dnsimple.com/v1/registrar/auto-renewal/#disable
      #
      # @param  [#to_s] domain The domain id or domain name.
      # @return [Struct::Domain]
      #
      # @raise  [RequestError] When the request fails.
      def disable_auto_renewal(domain, options = {})
        response = client.delete(Client.versioned("/domains/#{domain}/auto_renewal"), options)

        Struct::Domain.new(response["domain"])
      end

    end
  end
end
