module Dnsimple
  class Client
    module Tlds
      # Lists the tlds available for registration
      #
      # @see https://developer.dnsimple.com/v2/tlds/#list
      #
      # @example List TLDs in the first page
      #   client.tlds.list
      #
      # @example List TLDs, providing a specific page
      #   client.tlds.list(query: { page: 2 })
      #
      # @param  [Hash] options the filtering and sorting option
      # @return [Dnsimple::PaginatedResponse<Dnsimple::Struct::Tld>]
      #
      # @raise [Dnsimple::RequestError]
      def tlds(options = {})
        response = client.get(Client.versioned("/tlds"), options)

        Dnsimple::PaginatedResponse.new(response, response["data"].map { |r| Struct::Tld.new(r) })
      end
      alias :list :tlds
      alias :list_tlds :tlds

      # Lists ALL the TLDs in DNSimple.
      #
      # This method is similar to {#tlds}, but instead of returning the results of a specific page
      # it iterates all the pages and returns the entire collection.
      #
      # Please use this method carefully, as fetching the entire collection will increase the number of requests
      # you send to the API server and you may eventually risk to hit the throttle limit.
      #
      # @see https://developer.dnsimple.com/v2/tlds/#list
      # @see #tlds
      #
      # @example List all TLDs in DNSimple
      #     client.tlds.all
      #
      # @param  [Hash] options the filtering and sorting option
      # @return [Dnsimple::CollectionResponse<Dnsimple::Struct::Tld>]
      #
      # @raise [Dnsimple::RequestError]
      def all_tlds(options = {})
        paginate(:tlds, options)
      end
      alias :all :all_tlds

      # Gets a TLD's details
      #
      # @see https://developer.dnsimple.com/v2/tlds/#get
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
      # @see https://developer.dnsimple.com/v2/tlds/#extended-attributes
      #
      # @example Get extended attributes for a specific TLD
      #     client.tlds.extended_attributes('uk')
      #
      # @param  [#to_s] tld The TLD name.
      # @param  [Hash] options
      # @return [Dnsimple::CollectionResponse<Dnsimple::Struct::ExtendedAttribute>]
      #
      # @raise  [Dnsimple::NotFoundError]
      # @raise  [Dnsimple::RequestError]
      def extended_attributes(tld, options = {})
        response = client.get(Client.versioned("/tlds/%s/extended_attributes" % tld), options)

        Dnsimple::CollectionResponse.new(response, response["data"].map { |r| Struct::ExtendedAttribute.new(r) })
      end
    end
  end
end
