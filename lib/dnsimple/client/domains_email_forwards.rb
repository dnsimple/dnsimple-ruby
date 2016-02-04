module Dnsimple
  class Client
    module DomainsEmailForwards

      # Lists the email forwards for the domain.
      #
      # @see http://developer.dnsimple.com/v2/domains/email-forwards/#list
      #
      # @example List email forwards in the first page
      #   client.domains.email_forwards(1010, "example.com")
      #
      # @example List email forwards, provide a specific page
      #   client.domains.email_forwards(1010, "example.com", query: { page: 2 })
      #
      # @param  [Fixnum, Dnsimple::Client::WILDCARD_ACCOUNT] account_id the account ID or wildcard
      # @param  [#to_s] domain_id The domain id or domain name
      # @param  [Hash] options the filtering and sorting option
      # @return [Dnsimple::PaginatedResponse<Dnsimple::Struct::EmailForward>]
      #
      # @raise  [Dnsimple::RequestError]
      def email_forwards(account_id, domain_id, options = {})
        response = client.get(Client.versioned("/%s/domains/%s/email_forwards" % [account_id, domain_id]), options)

        Dnsimple::PaginatedResponse.new(response, response["data"].map { |r| Struct::EmailForward.new(r) })
      end

    end
  end
end
