module Dnsimple
  class Client
    module DomainsPrivacy

      # Enables WHOIS privacy for a domain.
      #
      # @see http://developer.dnsimple.com/domains/privacy/#enable
      #
      # @param  [#to_s] domain The domain id or domain name.
      #
      # @return [Struct::WhoisPrivacy]
      # @raise  [RequestError] When the request fails.
      def enable_whois_privacy(domain)
        response = client.post("v1/domains/#{domain}/whois_privacy")

        Struct::WhoisPrivacy.new(response["whois_privacy"])
      end

      # Disables WHOIS privacy for a domain.
      #
      # @see http://developer.dnsimple.com/domains/privacy/#disable
      #
      # @param  [#to_s] domain The domain id or domain name.
      #
      # @return [Struct::WhoisPrivacy]
      # @raise  [RequestError] When the request fails.
      def disable_whois_privacy(domain)
        response = client.delete("v1/domains/#{domain}/whois_privacy")

        Struct::WhoisPrivacy.new(response["whois_privacy"])
      end

    end
  end
end
