module Dnsimple
  class Client
    module DomainsCollaborators

      # Lists the collaborators for a domain.
      #
      # @see https://developer.dnsimple.com/v2/domains/collaborators/#list
      #
      # @example List collaborators in the first page
      #   client.domains.collaborators(1010, "example.com")
      #
      # @example List collaborators, provide a specific page
      #   client.domains.collaborators(1010, "example.com", page: 2)
      #
      # @param  [Integer] account_id the account ID
      # @param  [#to_s] domain_id the domain ID or name
      # @param  [Hash] options request options
      # @option options [Integer] :page current page (pagination)
      # @option options [Integer] :per_page number of entries to return (pagination)
      # @return [Dnsimple::PaginatedResponse<Dnsimple::Struct::Collaborator>]
      #
      # @raise  [Dnsimple::RequestError]
      def collaborators(account_id, domain_id, options = {})
        response = client.get(Client.versioned("/%s/domains/%s/collaborators" % [account_id, domain_id]), Options::ListOptions.new(options))

        Dnsimple::PaginatedResponse.new(response, response["data"].map { |r| Struct::Collaborator.new(r) })
      end

      # Add a collaborator to the domain.
      #
      # @see https://developer.dnsimple.com/v2/domains/collaborators/#add
      #
      # @example Add collaborator
      #   client.domains.add_collaborator(1010, "example.com", email: "user@example.com")
      #
      # @param  [Integer] account_id the account ID
      # @param  [#to_s] domain_id the domain ID or name
      # @param  [Hash] attributes user attributes
      # @option attributes [String] :email user email (mandatory)
      # @param  [Hash] options request options
      # @return [Dnsimple::PaginatedResponse<Dnsimple::Struct::Collaborator>]
      #
      # @raise  [Dnsimple::RequestError]
      def add_collaborator(account_id, domain_id, attributes, options = {})
        Extra.validate_mandatory_attributes(attributes, [:email])
        response = client.post(Client.versioned("/%s/domains/%s/collaborators" % [account_id, domain_id]), attributes, options)

        Dnsimple::Response.new(response, Struct::Collaborator.new(response["data"]))
      end

      # Removes a collaborator from the domain.
      #
      # WARNING: this cannot be undone.
      #
      # @see https://developer.dnsimple.com/v2/domains/collaborators/#remove
      #
      # @example Remove collaborator
      #   client.domains.remove_collaborator(1010, "example.com", 999)
      #
      # @param  [Integer] account_id the account ID
      # @param  [#to_s] domain_id the domain ID or name
      # @param  [#to_s] contact_id the contact ID
      # @param  [Hash] options request options
      # @return [Dnsimple::Response<nil>]
      #
      # @raise  [Dnsimple::NotFoundError]
      # @raise  [Dnsimple::RequestError]
      def remove_collaborator(account_id, domain_id, contact_id, options = {})
        response = client.delete(Client.versioned("/%s/domains/%s/collaborators/%s" % [account_id, domain_id, contact_id]), options)

        Dnsimple::Response.new(response, nil)
      end

    end
  end
end
