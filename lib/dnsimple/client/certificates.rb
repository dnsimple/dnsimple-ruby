module Dnsimple
  class Client
    module Certificates

      # Lists the certificates in the account.
      #
      # @see https://developer.dnsimple.com/v2/certificates/#list
      # @see #all_certificates
      #
      # @example List certificates in the first page
      #   client.certificates.list(1010)
      #
      # @example List certificates, provide a specific page
      #   client.certificates.list(1010, page: 2)
      #
      # @example List certificates, provide a sorting policy
      #   client.certificates.list(1010, sort: "email:asc")
      #
      # @param  [Fixnum] account_id the account ID
      # @param  [#to_s] domain_name the domain name
      # @param  [Hash] options the filtering and sorting options
      # @option options [Integer] :page current page (pagination)
      # @option options [Integer] :per_page number of entries to return (pagination)
      # @return [Dnsimple::PaginatedResponse<Dnsimple::Struct::Certificate>]
      #
      # @raise  [Dnsimple::RequestError]
      def certificates(account_id, domain_name, options = {})
        response = client.get(Client.versioned("/%s/domains/%s/certificates" % [account_id, domain_name]), Options::ListOptions.new(options))

        Dnsimple::PaginatedResponse.new(response, response["data"].map { |r| Struct::Certificate.new(r) })
      end

    end
  end
end
