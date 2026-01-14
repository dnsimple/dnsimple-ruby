# frozen_string_literal: true

module Dnsimple
  class Client
    module DomainsEmailForwards
      # Lists the email forwards for the domain.
      #
      # @see https://developer.dnsimple.com/v2/domains/email-forwards/#list
      #
      # @example List email forwards in the first page
      #   client.domains.email_forwards(1010, "example.com")
      #
      # @example List email forwards, provide a specific page
      #   client.domains.email_forwards(1010, "example.com", page: 2)
      #
      # @example List email forwards, provide a sorting policy
      #   client.domains.email_forwards(1010, "example.com", sort: "from:asc")
      #
      # @param  account_id [Integer] the account ID
      # @param  domain_id [#to_s] The domain ID or domain name
      # @param  options [Hash] the filtering and sorting options
      # @option options [Integer] :page current page (pagination)
      # @option options [Integer] :per_page number of entries to return (pagination)
      # @option options [String] :sort sorting policy
      # @return [Dnsimple::PaginatedResponse<Dnsimple::Struct::EmailForward>]
      #
      # @raise  [Dnsimple::NotFoundError]
      # @raise  [Dnsimple::RequestError]
      def email_forwards(account_id, domain_id, options = {})
        response = client.get(Client.versioned("/%s/domains/%s/email_forwards" % [account_id, domain_id]), Options::ListOptions.new(options))

        Dnsimple::PaginatedResponse.new(response, response["data"].map { |r| Struct::EmailForward.new(r) })
      end

      # Lists ALL the email forwards for the domain.
      #
      # This method is similar to {#email_forwards}, but instead of returning the results of a specific page
      # it iterates all the pages and returns the entire collection.
      #
      # Please use this method carefully, as fetching the entire collection will increase the number of requests
      # you send to the API server and you may eventually risk to hit the throttle limit.
      #
      # @see https://developer.dnsimple.com/v2/domains/email-forwards/#list
      # @see #email_forwards
      #
      # @param  account_id [Integer] the account ID
      # @param  domain_id [#to_s] The domain ID or domain name
      # @param  options [Hash] the filtering and sorting option
      # @option options [Integer] :page current page (pagination)
      # @option options [Integer] :per_page number of entries to return (pagination)
      # @option options [String] :sort sorting policy
      # @return [Dnsimple::CollectionResponse<Dnsimple::Struct::EmailForward>]
      #
      # @raise  [Dnsimple::RequestError]
      def all_email_forwards(account_id, domain_id, options = {})
        paginate(:email_forwards, account_id, domain_id, options)
      end

      # Creates an email forward for the domain.
      #
      # @see https://developer.dnsimple.com/v2/domains/email-forwards/#create
      #
      # @param  account_id [Integer] the account ID
      # @param  domain_id [#to_s] The domain ID or domain name
      # @param  attributes [Hash]
      # @param  options [Hash]
      # @return [Dnsimple::Response<Dnsimple::Struct::EmailForward>]
      #
      # @raise  [Dnsimple::RequestError]
      def create_email_forward(account_id, domain_id, attributes, options = {})
        Extra.validate_mandatory_attributes(attributes, [:alias_name, :destination_email])
        response = client.post(Client.versioned("/%s/domains/%s/email_forwards" % [account_id, domain_id]), attributes, options)

        Dnsimple::Response.new(response, Struct::EmailForward.new(response["data"]))
      end

      # Gets a email forward for the domain.
      #
      # @see https://developer.dnsimple.com/v2/domains/email-forwards/#get
      #
      # @param  account_id [Integer] the account ID
      # @param  domain_id [#to_s] The domain ID or domain name
      # @param  email_forward_id [#to_s] The email forward ID
      # @param  options [Hash]
      # @return [Dnsimple::Response<Dnsimple::Struct::EmailForward>]
      #
      # @raise  [Dnsimple::NotFoundError]
      # @raise  [Dnsimple::RequestError]
      def email_forward(account_id, domain_id, email_forward_id, options = {})
        response = client.get(Client.versioned("/%s/domains/%s/email_forwards/%s" % [account_id, domain_id, email_forward_id]), options)

        Dnsimple::Response.new(response, Struct::EmailForward.new(response["data"]))
      end

      # Deletes an email forward for the domain.
      #
      # WARNING: this cannot be undone.
      #
      # @see https://developer.dnsimple.com/v2/domains/email-forwards/#delete
      #
      # @param  account_id [Integer] the account ID
      # @param  domain_id [#to_s] The domain ID or domain name
      # @param  email_forward_id [#to_s] The email forward ID
      # @param  options [Hash]
      # @return [Dnsimple::Response<nil>]
      #
      # @raise  [Dnsimple::NotFoundError]
      # @raise  [Dnsimple::RequestError]
      def delete_email_forward(account_id, domain_id, email_forward_id, options = {})
        response = client.delete(Client.versioned("/%s/domains/%s/email_forwards/%s" % [account_id, domain_id, email_forward_id]), nil, options)

        Dnsimple::Response.new(response, nil)
      end
    end
  end
end
