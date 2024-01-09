# frozen_string_literal: true

module Dnsimple
  class Client
    module DomainsPushes

      # Initiate a push for the domain.
      #
      # @see https://developer.dnsimple.com/v2/domains/pushes/#initiate
      #
      # @example Initiate a domain pushe for example.com:
      #   client.domains.initiate_push(1010, "example.com", new_account_email: "admin@target-account.test")
      #
      # @param  [Integer] account_id the account ID
      # @param  [#to_s] domain_id The domain ID or domain name
      # @param  [Hash] attributes
      # @option attributes [String] :new_account_email the target account email (mandatory)
      # @param  [Hash] options
      # @return [Dnsimple::Response<Dnsimple::Struct::DomainPush>]
      #
      # @raise  [Dnsimple::RequestError]
      def initiate_push(account_id, domain_id, attributes, options = {})
        Extra.validate_mandatory_attributes(attributes, [:new_account_email])
        response = client.post(Client.versioned("/%s/domains/%s/pushes" % [account_id, domain_id]), attributes, options)

        Dnsimple::Response.new(response, Struct::DomainPush.new(response["data"]))
      end

      # Lists the pushes for the domain.
      #
      # @see https://developer.dnsimple.com/v2/domains/pushes/#list
      #
      # @example List domain pushes in the first page
      #   client.domains.pushes(2020)
      #
      # @example List domain pushes, provide a specific page
      #   client.domains.pushes(2020, page: 2)
      #
      # @param  [Integer] account_id the account ID
      # @param  [Hash] options
      # @option options [Integer] :page current page (pagination)
      # @option options [Integer] :per_page number of entries to return (pagination)
      # @return [Dnsimple::PaginatedResponse<Dnsimple::Struct::DomainPush>]
      #
      # @raise  [Dnsimple::NotFoundError]
      # @raise  [Dnsimple::RequestError]
      def pushes(account_id, options = {})
        response = client.get(Client.versioned("/%s/pushes" % [account_id]), Options::ListOptions.new(options))

        Dnsimple::PaginatedResponse.new(response, response["data"].map { |r| Struct::DomainPush.new(r) })
      end

      # Accept a domain push.
      #
      # @see https://developer.dnsimple.com/v2/domains/pushes/#accept
      #
      # @example Accept a domain push in the target account:
      #   client.domains.accept_push(2020, 1, contact_id: 2)
      #
      # @param  [Integer] account_id the target account ID
      # @param  [Integer] push_id the domain push ID
      # @param  [Hash] options
      # @param  [Hash] attributes
      # @option attributes [Integer] :contact_id the contact ID (mandatory)
      # @return [Dnsimple::Response<nil>]
      #
      # @raise  [Dnsimple::NotFoundError]
      # @raise  [Dnsimple::RequestError]
      def accept_push(account_id, push_id, attributes, options = {})
        Extra.validate_mandatory_attributes(attributes, [:contact_id])
        response = client.post(Client.versioned("/%s/pushes/%s" % [account_id, push_id]), attributes, options)

        Dnsimple::Response.new(response, nil)
      end

      # Reject a domain push.
      #
      # @see https://developer.dnsimple.com/v2/domains/pushes/#reject
      #
      # @example Reject a domain push in the target account:
      #   client.domains.reject_push(2020, 1, contact_id: 2)
      #
      # @param  [Integer] account_id the target account ID
      # @param  [Integer] push_id the domain push ID
      # @param  [Hash] options
      # @return [Dnsimple::Response<nil>]
      #
      # @raise  [Dnsimple::NotFoundError]
      # @raise  [Dnsimple::RequestError]
      def reject_push(account_id, push_id, options = {})
        response = client.delete(Client.versioned("/%s/pushes/%s" % [account_id, push_id]), options)

        Dnsimple::Response.new(response, nil)
      end

    end
  end
end
