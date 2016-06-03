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
      #   client.domains.email_forwards(1010, "example.com", query: { page: 2 })
      #
      # @param  [Fixnum] account_id the account ID
      # @param  [#to_s] domain_id The domain ID or domain name
      # @param  [Hash] options the filtering and sorting option
      # @return [Dnsimple::PaginatedResponse<Dnsimple::Struct::EmailForward>]
      #
      # @raise  [Dnsimple::NotFoundError]
      # @raise  [Dnsimple::RequestError]
      def email_forwards(account_id, domain_id, options = {})
        response = client.get(Client.versioned("/%s/domains/%s/email_forwards" % [account_id, domain_id]), options)

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
      # @param  [Fixnum] account_id the account ID
      # @param  [#to_s] domain_id The domain ID or domain name
      # @param  [Hash] options the filtering and sorting option
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
      # @param  [Fixnum] account_id the account ID
      # @param  [#to_s] domain_id The domain ID or domain name
      # @param  [Hash] attributes
      # @param  [Hash] options
      # @return [Dnsimple::Response<Dnsimple::Struct::EmailForward>]
      #
      # @raise  [Dnsimple::RequestError]
      def create_email_forward(account_id, domain_id, attributes, options = {})
        Extra.validate_mandatory_attributes(attributes, [:from, :to])
        response = client.post(Client.versioned("/%s/domains/%s/email_forwards" % [account_id, domain_id]), attributes, options)

        Dnsimple::Response.new(response, Struct::EmailForward.new(response["data"]))
      end

      # Gets a email forward for the domain.
      #
      # @see https://developer.dnsimple.com/v2/domains/email-forwards/#get
      #
      # @param  [Fixnum] account_id the account ID
      # @param  [#to_s] domain_id The domain ID or domain name
      # @param  [#to_s] email_forward_id The email forward ID
      # @param  [Hash] options
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
      # @param  [Fixnum] account_id the account ID
      # @param  [#to_s] domain_id The domain ID or domain name
      # @param  [#to_s] email_forward_id The email forward ID
      # @param  [Hash] options
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
