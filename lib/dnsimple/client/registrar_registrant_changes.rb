# frozen_string_literal: true

module Dnsimple
  class Client
    module RegistrarRegistrantChanges
      # Retrieves the requirements of a registrant change
      #
      # @example Check the requirements to change the contact for example.com to contact 1234:
      #   client.registrar.check_registrant_change(1010, { domain_id: "example.com", contact_id: 1234 })
      #
      # @param  account_id [Integer] the account ID
      # @param  attributes [Hash] the attributes to check the registrant change
      # @option attributes [String, Integer] :domain_id the domain ID to check
      # @option attributes [Integer] :contact_id the contact ID to check against
      # @param  options [Hash]
      # @return [Struct::RegistrantChangeCheck]
      #
      # @raise  [RequestError] When the request fails.
      def check_registrant_change(account_id, attributes, options = {})
        Extra.validate_mandatory_attributes(attributes, [:domain_id, :contact_id])
        endpoint = Client.versioned("/%s/registrar/registrant_changes/check" % [account_id])
        response = client.post(endpoint, attributes, options)

        Dnsimple::Response.new(response, Struct::RegistrantChangeCheck.new(response["data"]))
      end

      # Retrieves the details of an existing registrant change.
      #
      # @example Retrieve the registrant change 42:
      #   client.registrar.get_registrant_change(1010, 42)
      #
      # @param  account_id [Integer] the Account id
      # @param  registrant_change_id [#to_s] the registrant change id
      # @param  options [Hash]
      #
      # @return [Struct::RegistrantChange]
      #
      # @raise [NotFoundError] When record is not found.
      # @raise [RequestError] When the request fails.
      def get_registrant_change(account_id, registrant_change_id, options = {})
        endpoint = Client.versioned("/%s/registrar/registrant_changes/%s" % [account_id, registrant_change_id])
        response = client.get(endpoint, options)

        Dnsimple::Response.new(response, Struct::RegistrantChange.new(response["data"]))
      end

      # Start registrant change.
      #
      # @example Start a registrant change for example.com to contact 1234:
      #   including WHOIS privacy for the domain and enabling auto renewal:
      #   client.registrar.create_registrant_change(1010, { domain_id: "example.com", contact_id: 1234, extended_attributes: { "x-fi-registrant-idnumber" => "1234" } })
      #
      # @param  account_id [Integer] the account ID
      # @param  attributes [Hash] the attributes to start a registrant change
      # @option attributes [String, Integer] :domain_id the domain ID
      # @option attributes [Integer] :contact_id the contact ID to change to
      # @option attributes [Array<Hash>, nil] :extended_attributes the extended attributes to pass to the registry
      # @param  options [Hash]
      # @return [Struct::RegistrantChange]
      #
      # @raise  [RequestError] When the request fails.
      def create_registrant_change(account_id, attributes, options = {})
        Extra.validate_mandatory_attributes(attributes, [:domain_id, :contact_id])
        endpoint = Client.versioned("/%s/registrar/registrant_changes" % [account_id])
        response = client.post(endpoint, attributes, options)

        Dnsimple::Response.new(response, Struct::RegistrantChange.new(response["data"]))
      end

      # List registrant changes in the account.
      #
      # @example List registrant changes for the account:
      #   client.registrar.list_registrant_changes(1010)
      #
      # @param  account_id [Integer] the account ID
      # @param  options [Hash]
      # @return [Dnsimple::PaginatedResponse<Struct::DomainRegistration>]
      #
      # @raise  [NotFoundError] When record is not found.
      # @raise  [RequestError]  When the request fails.
      def list_registrant_changes(account_id, options = {})
        endpoint = Client.versioned("/%s/registrar/registrant_changes" % [account_id])
        response = client.get(endpoint, options)

        Dnsimple::PaginatedResponse.new(response, response["data"].map { |r| Struct::RegistrantChange.new(r) })
      end

      # Cancel an ongoing registrant change from the account.
      #
      # @example Cancel a registrant change 42:
      #   client.registrar.delete_registrant_change(1010, 42)
      #
      # @param  account_id [Integer] the account ID
      # @param  registrant_change_id [#to_s] the registrant change ID
      # @param  options [Hash]
      # @return [Dnsimple::Response<nil>]
      #
      # @raise  [NotFoundError] When record is not found.
      # @raise  [RequestError] When the request fails.
      def delete_registrant_change(account_id, registrant_change_id, options = {})
        endpoint = Client.versioned("/%s/registrar/registrant_changes/%s" % [account_id, registrant_change_id])
        response = client.delete(endpoint, nil, options)

        Dnsimple::Response.new(response, nil)
      end
    end
  end
end
