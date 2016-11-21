module Dnsimple
  class Client
    module Collaborators

      # Lists the collaborators for a domain.
      #
      # @see https://developer.dnsimple.com/v2/domains/collaborators/#list
      #
      # @example List collaborators in the first page
      #   client.collaborators.list(1010, "example.com")
      #
      # @example List collaborators, provide a specific page
      #   client.collaborators.list(1010, "example.com", page: 2)
      #
      # @param  [Fixnum] account_id the account ID
      # @param  [#to_s] domain_name the domain name
      # @param  [Hash] request options
      # @option options [Integer] :page current page (pagination)
      # @option options [Integer] :per_page number of entries to return (pagination)
      # @return [Dnsimple::PaginatedResponse<Dnsimple::Struct::Collaborator>]
      #
      # @raise  [Dnsimple::RequestError]
      def collaborators(account_id, domain_id, options = {})
        response = client.get(Client.versioned("/%s/domains/%s/collaborators" % [account_id, domain_id]), Options::ListOptions.new(options))

        Dnsimple::PaginatedResponse.new(response, response["data"].map { |r| Struct::Collaborator.new(r) })
      end

    end
  end
end
