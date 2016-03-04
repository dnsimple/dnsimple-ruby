module Dnsimple
  class Client
    module RegistrarWhoisPrivacy

      # Gets the whois privacy for the domain
      #
      # @see https://developer.dnsimple.com/v2/registrar/whois-privacy/#get
      #
      # @example Get the whois privacy for "example.com":
      #   client.registrar.get_whois_privacy(1010, "example.com")
      #
      # @param  [Fixnum] account_id the account ID
      # @param  [#to_s] domain_name The domain name to check.
      # @param  [Hash] options
      # @return [Struct::WhoisPrivacy]
      #
      # @raise  [RequestError] When the request fails.
      def whois_privacy(account_id, domain_name, options = {})
        endpoint = Client.versioned("/%s/registrar/domains/%s/whois_privacy" % [account_id, domain_name])
        response = client.get(endpoint, options)

        Dnsimple::Response.new(response, Struct::WhoisPrivacy.new(response["data"]))
      end

    end
  end
end
