module Dnsimple
  class Client
    module RegistrarAutoRenewal

      # Enable auto renewal for the domain in the account.
      #
      # @see https://developer.dnsimple.com/v2/registrar/auto-renewal/
      #
      # @param  [Fixnum, Dnsimple::Client::WILDCARD_ACCOUNT] account_id the account ID or wildcard
      # @param  [String] domain_id the domain name
      # @param  [Hash] options
      # @return [Dnsimple::Response<nil>]
      #
      # @raise  [Dnsimple::NotFoundError]
      # @raise  [Dnsimple::RequestError]
      def enable_auto_renewal(account_id, domain_id, options={})
        response = client.put(Client.versioned("/%s/registrar/domains/%s/auto_renewal" % [account_id, domain_id]), options)

        Dnsimple::Response.new(response, nil)
      end

      # Disable auto renewal for the domain in the account.
      #
      # @see https://developer.dnsimple.com/v2/registrar/auto-renewal/
      #
      # @param  [Fixnum, Dnsimple::Client::WILDCARD_ACCOUNT] account_id the account ID or wildcard
      # @param  [String] domain_id the domain name
      # @param  [Hash] options
      # @return [Dnsimple::Response<nil>]
      #
      # @raise  [Dnsimple::NotFoundError]
      # @raise  [Dnsimple::RequestError]
      def disable_auto_renewal(account_id, domain_id, options={})
        response = client.delete(Client.versioned("/%s/registrar/domains/%s/auto_renewal" % [account_id, domain_id]), options)

        Dnsimple::Response.new(response, nil)
      end

    end
  end
end
