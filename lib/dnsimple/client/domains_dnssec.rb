# frozen_string_literal: true

module Dnsimple
  class Client
    module DomainsDnssec

      # Enable DNSSEC for the domain in the account.
      #
      # @see https://developer.dnsimple.com/v2/dnssec/#enable
      #
      # @param  [Integer] account_id the account ID
      # @param  [#to_s] domain_name the domain name
      # @param  [Hash] options
      # @return [Dnsimple::Response<Dnsimple::Struct::Dnssec>]
      #
      # @raise  [Dnsimple::NotFoundError]
      # @raise  [Dnsimple::RequestError]
      def enable_dnssec(account_id, domain_name, options = {})
        response = client.post(Client.versioned("/%s/domains/%s/dnssec" % [account_id, domain_name]), nil, options)

        Dnsimple::Response.new(response, Struct::Dnssec.new(response["data"]))
      end

      # Disable DNSSEC for the domain in the account.
      #
      # @see https://developer.dnsimple.com/v2/dnssec/#disable
      #
      # @param  [Integer] account_id the account ID
      # @param  [#to_s] domain_name the domain name
      # @param  [Hash] options
      # @return [Dnsimple::Response<nil>]
      #
      # @raise  [Dnsimple::NotFoundError]
      # @raise  [Dnsimple::RequestError]
      def disable_dnssec(account_id, domain_name, options = {})
        response = client.delete(Client.versioned("/%s/domains/%s/dnssec" % [account_id, domain_name]), nil, options)

        Dnsimple::Response.new(response, nil)
      end

      # Get the DNSSEC status for the domain in the account.
      #
      # @see https://developer.dnsimple.com/v2/dnssec/#get
      #
      # @param  [Integer] account_id the account ID
      # @param  [#to_s] domain_name the domain name
      # @param  [Hash] options
      # @return [Dnsimple::Response<Dnsimple::Struct::Dnssec>]
      #
      # @raise  [Dnsimple::NotFoundError]
      # @raise  [Dnsimple::RequestError]
      def get_dnssec(account_id, domain_name, options = {})
        response = client.get(Client.versioned("/%s/domains/%s/dnssec" % [account_id, domain_name]), options)

        Dnsimple::Response.new(response, Struct::Dnssec.new(response["data"]))
      end
    end
  end
end
