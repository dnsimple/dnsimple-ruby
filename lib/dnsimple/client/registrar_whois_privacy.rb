module Dnsimple
  class Client
    module RegistrarWhoisPrivacy

      # Gets the whois privacy for the domain.
      #
      # @see https://developer.dnsimple.com/v2/registrar/whois-privacy/#get
      #
      # @example Get the whois privacy for "example.com":
      #   client.registrar.whois_privacy(1010, "example.com")
      #
      # @param  [Fixnum] account_id the account ID
      # @param  [#to_s] domain_name the domain name
      # @param  [Hash] options
      # @return [Struct::WhoisPrivacy]
      #
      # @raise  [RequestError] When the request fails.
      def whois_privacy(account_id, domain_name, options = {})
        endpoint = whois_privacy_endpoint(account_id, domain_name)
        response = client.get(endpoint, options)

        Dnsimple::Response.new(response, Struct::WhoisPrivacy.new(response["data"]))
      end

      # Enables whois privacy for the domain.
      #
      # @see https://developer.dnsimple.com/v2/registrar/whois-privacy/#enable
      #
      # @example Enable whois privacy for "example.com":
      #   client.registrar.enable_whois_privacy(1010, "example.com")
      #
      # @param  [Fixnum] account_id the account ID
      # @param  [#to_s] domain_name the domain name
      # @param  [Hash] options
      # @return [Struct::WhoisPrivacy]
      #
      # @raise  [RequestError] When the request fails.
      def enable_whois_privacy(account_id, domain_name, options = {})
        endpoint = whois_privacy_endpoint(account_id, domain_name)
        response = client.put(endpoint, nil, options)

        Dnsimple::Response.new(response, Struct::WhoisPrivacy.new(response["data"]))
      end

      # Disables whois privacy for the domain.
      #
      # @see https://developer.dnsimple.com/v2/registrar/whois-privacy/#disable
      #
      # @example Disable whois privacy for "example.com":
      #   client.registrar.disable_whois_privacy(1010, "example.com")
      #
      # @param  [Fixnum] account_id the account ID
      # @param  [#to_s] domain_name The domain name to check.
      # @param  [Hash] options
      # @return [Struct::WhoisPrivacy]
      #
      # @raise  [RequestError] When the request fails.
      def disable_whois_privacy(account_id, domain_name, options = {})
        endpoint = whois_privacy_endpoint(account_id, domain_name)
        response = client.delete(endpoint, nil, options)

        Dnsimple::Response.new(response, Struct::WhoisPrivacy.new(response["data"]))
      end


      private

      def whois_privacy_endpoint(account_id, domain_name)
        Client.versioned("/%s/registrar/domains/%s/whois_privacy" % [account_id, domain_name])
      end

    end
  end
end
