# frozen_string_literal: true

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
      # @param  [Integer] account_id the account ID
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
      # @param  [Integer] account_id the account ID
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
      # @param  [Integer] account_id the account ID
      # @param  [#to_s] domain_name The domain name
      # @param  [Hash] options
      # @return [Struct::WhoisPrivacy]
      #
      # @raise  [RequestError] When the request fails.
      def disable_whois_privacy(account_id, domain_name, options = {})
        endpoint = whois_privacy_endpoint(account_id, domain_name)
        response = client.delete(endpoint, nil, options)

        Dnsimple::Response.new(response, Struct::WhoisPrivacy.new(response["data"]))
      end

      # Renews whois privacy for the domain.
      #
      # @see https://developer.dnsimple.com/v2/registrar/whois-privacy/#renew
      #
      # @example Renew whois privacy for "example.com":
      #   client.registrar.renew_whois_privacy(1010, "example.com")
      #
      # @param  account_id [Integer] the account ID
      # @param  domain_name [#to_s] The domain name
      # @param  options [Hash]
      # @return [Struct::WhoisPrivacy]
      #
      # @raise  [RequestError] When the request fails.
      def renew_whois_privacy(account_id, domain_name, options = {})
        endpoint = "#{whois_privacy_endpoint(account_id, domain_name)}/renewals"
        response = client.post(endpoint, nil, options)

        Dnsimple::Response.new(response, Struct::WhoisPrivacyRenewal.new(response["data"]))
      end


      private

      def whois_privacy_endpoint(account_id, domain_name)
        Client.versioned("/%s/registrar/domains/%s/whois_privacy" % [account_id, domain_name])
      end
    end
  end
end
