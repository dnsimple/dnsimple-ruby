module Dnsimple
  class Client
    module DomainsPrivacy

      # Enables WHOIS privacy for a domain.
      #
      # @see http://developer.dnsimple.com/v1/registrar/privacy/#enable
      #
      # @param  [#to_s] domain The domain id or domain name.
      # @return [Struct::WhoisPrivacy]
      #
      # @raise  [RequestError] When the request fails.
      def enable_whois_privacy(domain, options = {})
        response = client.post(Client.versioned("domains/#{domain}/whois_privacy"), options)

        Struct::WhoisPrivacy.new(response["whois_privacy"])
      end

      # Disables WHOIS privacy for a domain.
      #
      # @see http://developer.dnsimple.com/v1/registrar/privacy/#disable
      #
      # @param  [#to_s] domain The domain id or domain name.
      # @return [Struct::WhoisPrivacy]
      #
      # @raise  [RequestError] When the request fails.
      def disable_whois_privacy(domain, options = {})
        response = client.delete(Client.versioned("domains/#{domain}/whois_privacy"), options)

        Struct::WhoisPrivacy.new(response["whois_privacy"])
      end

    end
  end
end
