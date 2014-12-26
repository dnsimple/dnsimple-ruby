module Dnsimple
  class Client
    module DomainsAutorenewals

      # Enables auto-renewal for a domain.
      #
      # @see http://developer.dnsimple.com/domains/autorenewal/#enable
      #
      # @param  [#to_s] domain The domain id or domain name.
      #
      # @return [Struct::Domain]
      # @raise  [RequestError] When the request fails.
      def enable_auto_renewal(domain)
        response = client.post("v1/domains/#{domain}/auto_renewal")

        Struct::Domain.new(response["domain"])
      end

      # Disables auto-renewal for a domain.
      #
      # @see http://developer.dnsimple.com/domains/autorenewal/#disable
      #
      # @param  [#to_s] domain The domain id or domain name.
      #
      # @return [Struct::Domain]
      # @raise  [RequestError] When the request fails.
      def disable_auto_renewal(domain)
        response = client.delete("v1/domains/#{domain}/auto_renewal")

        Struct::Domain.new(response["domain"])
      end

    end
  end
end
