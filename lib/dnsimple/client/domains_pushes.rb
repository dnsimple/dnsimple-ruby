module Dnsimple
  class Client
    module DomainsPushes

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
      # @param  [Fixnum] account_id the account ID
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
    end

  end
end
