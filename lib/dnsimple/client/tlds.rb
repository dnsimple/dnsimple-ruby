module Dnsimple
  class Client
    module Tlds
      # Lists the TLDs available for registration
      #
      # @see https://developer.dnsimple.com/v2/tlds/#listTlds
      #
      # @example List TLDs in the first page
      #   client.tlds.list_tlds
      #
      # @example List TLDs, providing a specific page
      #   client.tlds.list_tlds(page: 2)
      #
      # @example List TLDs, providing sorting policy
      #   client.tlds.list_tlds(sort: "tld:asc")
      #
      # @param  [Hash] options the filtering and sorting options
      # @option options [Integer] :page current page (pagination)
      # @option options [Integer] :per_page number of entries to return (pagination)
      # @option options [String] :sort sorting policy
      # @return [Dnsimple::PaginatedResponse<Dnsimple::Struct::Tld>]
      #
      # @raise [Dnsimple::RequestError]
      def list_tlds(options = {})
        response = client.get(Client.versioned("/tlds"), Options::ListOptions.new(options))

        Dnsimple::PaginatedResponse.new(response, response["data"].map { |r| Struct::Tld.new(r) })
      end

      # Lists ALL the TLDs in DNSimple.
      #
      # This method is similar to {#tlds}, but instead of returning the results of a specific page
      # it iterates all the pages and returns the entire collection.
      #
      # Please use this method carefully, as fetching the entire collection will increase the number of requests
      # you send to the API server and you may eventually risk to hit the throttle limit.
      #
      # @see https://developer.dnsimple.com/v2/tlds/#listTlds
      # @see #list_tlds
      #
      # @example List all TLDs in DNSimple
      #     client.tlds.all
      #
      # @param  [Hash] options the filtering and sorting options
      # @option options [Integer] :page current page (pagination)
      # @option options [Integer] :per_page number of entries to return (pagination)
      # @option options [String] :sort sorting policy
      # @return [Dnsimple::CollectionResponse<Dnsimple::Struct::Tld>]
      #
      # @raise [Dnsimple::RequestError]
      def all_tlds(options = {})
        paginate(:list_tlds, options)
      end

      # Gets a TLD details
      #
      # @see https://developer.dnsimple.com/v2/tlds/#getTld
      #
      # @example Get information on a specific TLD
      #     client.tlds.tld('com')
      #
      # @param  [#to_s] tld The TLD name.
      # @param  [Hash] options
      # @return [Dnsimple::Response<Dnsimple::Struct::Tld>]
      #
      # @raise  [Dnsimple::NotFoundError]
      # @raise  [Dnsimple::RequestError]
      def tld(tld, options = {})
        response = client.get(Client.versioned("/tlds/%s" % tld), options)

        Dnsimple::Response.new(response, Struct::Tld.new(response["data"]))
      end

      # Gets the extended attributes for a TLD.
      #
      # @see https://developer.dnsimple.com/v2/tlds/#getTldExtendedAttributes
      #
      # @example Get extended attributes for a specific TLD
      #     client.tlds.tld_extended_attributes('uk')
      #
      # @param  [#to_s] tld The TLD name.
      # @param  [Hash] options
      # @return [Dnsimple::CollectionResponse<Dnsimple::Struct::ExtendedAttribute>]
      #
      # @raise  [Dnsimple::NotFoundError]
      # @raise  [Dnsimple::RequestError]
      def tld_extended_attributes(tld, options = {})
        response = client.get(Client.versioned("/tlds/%s/extended_attributes" % tld), options)

        Dnsimple::CollectionResponse.new(response, response["data"].map { |r| Struct::ExtendedAttribute.new(r) })
      end
    end
  end
end
