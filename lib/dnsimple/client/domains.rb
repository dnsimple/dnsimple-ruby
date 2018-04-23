module Dnsimple
  class Client
    module Domains

      # Lists the domains in the account.
      #
      # @see https://developer.dnsimple.com/v2/domains/#list
      # @see #all_domains
      #
      # @example List domains in the first page
      #   client.domains.list(1010)
      #
      # @example List domains, provide a specific page
      #   client.domains.list(1010, page: 2)
      #
      # @example List domains, provide a sorting policy
      #   client.domains.list(1010, sort: "expires_on:asc")
      #
      # @example List domains, provide a filtering policy
      #   client.domains.list(1010, filter: { name_like: "example" })
      #
      # @param  [Integer] account_id the account ID
      # @param  [Hash] options the filtering and sorting options
      # @option options [Integer] :page current page (pagination)
      # @option options [Integer] :per_page number of entries to return (pagination)
      # @option options [String] :sort sorting policy
      # @option options [Hash] :filter filtering policy
      # @return [Dnsimple::PaginatedResponse<Dnsimple::Struct::Domain>]
      #
      # @raise  [Dnsimple::RequestError]
      def domains(account_id, options = {})
        response = client.get(Client.versioned("/%s/domains" % [account_id]), Options::ListOptions.new(options))

        Dnsimple::PaginatedResponse.new(response, response["data"].map { |r| Struct::Domain.new(r) })
      end
      alias list_domains domains

      # Lists ALL the domains in the account.
      #
      # This method is similar to {#domains}, but instead of returning the results of a specific page
      # it iterates all the pages and returns the entire collection.
      #
      # Please use this method carefully, as fetching the entire collection will increase the number of requests
      # you send to the API server and you may eventually risk to hit the throttle limit.
      #
      # @see https://developer.dnsimple.com/v2/domains/#list
      # @see #domains
      #
      # @param  [Integer] account_id the account ID
      # @param  [Hash] options the filtering and sorting option
      # @option options [Integer] :page current page (pagination)
      # @option options [Integer] :per_page number of entries to return (pagination)
      # @option options [String] :sort sorting policy
      # @option options [Hash] :filter filtering policy
      # @return [Dnsimple::CollectionResponse<Dnsimple::Struct::Domain>]
      #
      # @raise  [Dnsimple::RequestError]
      def all_domains(account_id, options = {})
        paginate(:domains, account_id, options)
      end

      # Creates a domain in the account.
      #
      # @see https://developer.dnsimple.com/v2/domains/#create
      #
      # @param  [Integer] account_id the account ID
      # @param  [Hash] attributes
      # @param  [Hash] options
      # @return [Dnsimple::Response<Dnsimple::Struct::Domain>]
      #
      # @raise  [Dnsimple::RequestError]
      def create_domain(account_id, attributes, options = {})
        Extra.validate_mandatory_attributes(attributes, [:name])
        options  = options.merge(attributes)
        response = client.post(Client.versioned("/%s/domains" % [account_id]), attributes, options)

        Dnsimple::Response.new(response, Struct::Domain.new(response["data"]))
      end

      # Gets a domain from the account.
      #
      # @see https://developer.dnsimple.com/v2/domains/#get
      #
      # @param  [Integer] account_id the account ID
      # @param  [#to_s] domain_id The domain ID or domain name
      # @param  [Hash] options
      # @return [Dnsimple::Response<Dnsimple::Struct::Domain>]
      #
      # @raise  [Dnsimple::NotFoundError]
      # @raise  [Dnsimple::RequestError]
      def domain(account_id, domain_id, options = {})
        response = client.get(Client.versioned("/%s/domains/%s" % [account_id, domain_id]), options)

        Dnsimple::Response.new(response, Struct::Domain.new(response["data"]))
      end

      # Deletes a domain from the account.
      #
      # WARNING: this cannot be undone.
      #
      # @see https://developer.dnsimple.com/v2/domains/#delete
      #
      # @param  [Integer] account_id the account ID
      # @param  [#to_s] domain_id The domain ID or domain name
      # @param  [Hash] options
      # @return [Dnsimple::Response<nil>]
      #
      # @raise  [Dnsimple::NotFoundError]
      # @raise  [Dnsimple::RequestError]
      def delete_domain(account_id, domain_id, options = {})
        response = client.delete(Client.versioned("/%s/domains/%s" % [account_id, domain_id]), nil, options)

        Dnsimple::Response.new(response, nil)
      end

      # Resets the domain token.
      #
      # @see https://developer.dnsimple.com/v2/domains/#reset-token
      #
      # @param  [Integer] account_id the account ID
      # @param  [#to_s] domain_id The domain ID or domain name
      # @param  [Hash] options
      # @return [Dnsimple::Response<nil>]
      #
      # @raise  [Dnsimple::NotFoundError]
      # @raise  [Dnsimple::RequestError]
      def reset_domain_token(account_id, domain_id, options = {})
        response = client.post(Client.versioned("/%s/domains/%s/token" % [account_id, domain_id]), nil, options)

        Dnsimple::Response.new(response, Struct::Domain.new(response["data"]))
      end

    end
  end
end
