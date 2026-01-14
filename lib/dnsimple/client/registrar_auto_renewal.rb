# frozen_string_literal: true

module Dnsimple
  class Client
    module RegistrarAutoRenewal
      # Enable auto renewal for the domain in the account.
      #
      # @see https://developer.dnsimple.com/v2/registrar/auto-renewal/
      #
      # @param  account_id [Integer] the account ID
      # @param  domain_name [#to_s] the domain name
      # @param  options [Hash]
      # @return [Dnsimple::Response<nil>]
      #
      # @raise  [Dnsimple::NotFoundError]
      # @raise  [Dnsimple::RequestError]
      def enable_auto_renewal(account_id, domain_name, options = {})
        response = client.put(Client.versioned("/%s/registrar/domains/%s/auto_renewal" % [account_id, domain_name]), nil, options)

        Dnsimple::Response.new(response, nil)
      end

      # Disable auto renewal for the domain in the account.
      #
      # @see https://developer.dnsimple.com/v2/registrar/auto-renewal/
      #
      # @param  account_id [Integer] the account ID
      # @param  domain_name [#to_s] the domain name
      # @param  options [Hash]
      # @return [Dnsimple::Response<nil>]
      #
      # @raise  [Dnsimple::NotFoundError]
      # @raise  [Dnsimple::RequestError]
      def disable_auto_renewal(account_id, domain_name, options = {})
        response = client.delete(Client.versioned("/%s/registrar/domains/%s/auto_renewal" % [account_id, domain_name]), nil, options)

        Dnsimple::Response.new(response, nil)
      end
    end
  end
end
