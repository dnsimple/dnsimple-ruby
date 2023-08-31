# frozen_string_literal: true

module Dnsimple
  class Client
    module RegistrarTransferLock

      # Gets the transfer lock for the domain.
      #
      # @example Get the transfer lock for "example.com":
      #   client.registrar.get_domain_transfer_lock(1010, "example.com")
      #
      # @param  [#to_s] account_id the account ID
      # @param  [#to_s] domain_name the domain name
      # @param  [Hash] options
      # @return [Struct::TransferLock]
      #
      # @raise  [Dnsimple::NotFoundError]
      # @raise  [RequestError] When the request fails.
      def get_domain_transfer_lock(account_id, domain_name, options = {})
        response = client.get(Client.versioned("/%s/registrar/domains/%s/transfer_lock" % [account_id, domain_name]), options)

        Dnsimple::Response.new(response, Struct::TransferLock.new(response["data"]))
      end

      # Enable transfer lock for the domain in the account.
      #
      # @see https://developer.dnsimple.com/v2/registrar/#enableDomainTransferLock
      #
      # @param  [Integer] account_id the account ID
      # @param  [#to_s] domain_name the domain name
      # @param  [Hash] options
      # @return [Struct::TransferLock]
      #
      # @raise  [Dnsimple::NotFoundError]
      # @raise  [Dnsimple::RequestError]
      def enable_domain_transfer_lock(account_id, domain_name, options = {})
        response = client.post(Client.versioned("/%s/registrar/domains/%s/transfer_lock" % [account_id, domain_name]), nil, options)

        Dnsimple::Response.new(response, Struct::TransferLock.new(response["data"]))
      end

      # Disable trasnfer lock for the domain in the account.
      #
      # @see https://developer.dnsimple.com/v2/registrar/#disableDomainTransferLock
      #
      # @param  [Integer] account_id the account ID
      # @param  [#to_s] domain_name the domain name
      # @param  [Hash] options
      # @return [Struct::TransferLock]
      #
      # @raise  [Dnsimple::NotFoundError]
      # @raise  [Dnsimple::RequestError]
      def disable_domain_transfer_lock(account_id, domain_name, options = {})
        response = client.delete(Client.versioned("/%s/registrar/domains/%s/transfer_lock" % [account_id, domain_name]), nil, options)

        Dnsimple::Response.new(response, Struct::TransferLock.new(response["data"]))
      end

    end
  end
end
