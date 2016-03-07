module Dnsimple
  class Client
    module Tlds
      # Lists the tlds available for registration
      #
      # @see https://developer.dnsimple.com/v2/tlds/#list
      #
      # @example List tlds in the first page
      #   client.tlds.list
      #
      # @example List zones, providing a specific page
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
      # @param  [Hash] options the filtering and sorting option
      # @return [Dnsimple::CollectionResponse<Dnsimple::Struct::Tld>]
      #
      # @raise [Dnsimple::RequestError]
      def all_tlds(options = {})
        paginate(:tlds, options)
      end
      alias :all :all_tlds
    end
  end
end
