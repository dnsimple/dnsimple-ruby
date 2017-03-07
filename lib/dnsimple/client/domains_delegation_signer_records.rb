module Dnsimple
  class Client
    module DomainsDelegationSignerRecords

      # Lists the delegation signer records for the domain.
      #
      # @see https://developer.dnsimple.com/v2/domains/dnssec/#ds-record-list
      #
      # @example List delegation signer records in the first page
      #   client.domains.delegation_signer_records(1010, "example.com")
      #
      # @example List delegation signer records, provide a specific page
      #   client.domains.email_forwards(1010, "example.com", page: 2)
      #
      # @example List delegation signer records, provide a sorting policy
      #   client.domains.delegation_signer_records(1010, "example.com", sort: "from:asc")
      #
      # @param  [Integer] account_id the account ID
      # @param  [#to_s] domain_id The domain ID or domain name
      # @param  [Hash] options the filtering and sorting options
      # @option options [Integer] :page current page (pagination)
      # @option options [Integer] :per_page number of entries to return (pagination)
      # @option options [String] :sort sorting policy
      # @return [Dnsimple::PaginatedResponse<Dnsimple::Struct::DelegationSignerRecord>]
      #
      # @raise  [Dnsimple::NotFoundError]
      # @raise  [Dnsimple::RequestError]
      def delegation_signer_records(account_id, domain_id, options = {})
        response = client.get(Client.versioned("/%s/domains/%s/ds_records" % [account_id, domain_id]), Options::ListOptions.new(options))

        Dnsimple::PaginatedResponse.new(response, response["data"].map { |r| Struct::DelegationSignerRecord.new(r) })
      end

      # Lists ALL the delegation signer records for the domain.
      #
      # This method is similar to {#delegation_signer_records}, but instead of returning the results of a specific page
      # it iterates all the pages and returns the entire collection.
      #
      # Please use this method carefully, as fetching the entire collection will increase the number of requests
      # you send to the API server and you may eventually risk to hit the throttle limit.
      #
      # @see https://developer.dnsimple.com/v2/domains/dnssec/#ds-record-list
      # @see #email_forwards
      #
      # @param  [Integer] account_id the account ID
      # @param  [#to_s] domain_id The domain ID or domain name
      # @param  [Hash] options the filtering and sorting option
      # @option options [Integer] :page current page (pagination)
      # @option options [Integer] :per_page number of entries to return (pagination)
      # @option options [String] :sort sorting policy
      # @return [Dnsimple::CollectionResponse<Dnsimple::Struct::DelegationSignerRecord>]
      #
      # @raise  [Dnsimple::RequestError]
      def all_delegation_signer_records(account_id, domain_id, options = {})
        paginate(:delegation_signer_records, account_id, domain_id, options)
      end

      # Creates a delegation signer record for the domain.
      #
      # @see https://developer.dnsimple.com/v2/domains/dnssec/#ds-record-create
      #
      # @param  [Integer] account_id the account ID
      # @param  [#to_s] domain_id The domain ID or domain name
      # @param  [Hash] attributes
      # @param  [Hash] options
      # @return [Dnsimple::Response<Dnsimple::Struct::DelegationSignerRecord>]
      #
      # @raise  [Dnsimple::RequestError]
      def create_delegation_signer_record(account_id, domain_id, attributes, options = {})
        Extra.validate_mandatory_attributes(attributes, [:algorithm, :digest, :digest_type, :keytag])
        response = client.post(Client.versioned("/%s/domains/%s/ds_records" % [account_id, domain_id]), attributes, options)

        Dnsimple::Response.new(response, Struct::DelegationSignerRecord.new(response["data"]))
      end

      # Gets a delegation signer record for the domain.
      #
      # @see https://developer.dnsimple.com/v2/domains/dnssec/#ds-record-get
      #
      # @param  [Integer] account_id the account ID
      # @param  [#to_s] domain_id The domain ID or domain name
      # @param  [#to_s] ds_record_id The delegation signer record ID
      # @param  [Hash] options
      # @return [Dnsimple::Response<Dnsimple::Struct::DelegationSignerRecord>]
      #
      # @raise  [Dnsimple::NotFoundError]
      # @raise  [Dnsimple::RequestError]
      def delegation_signer_record(account_id, domain_id, ds_record_id, options = {})
        response = client.get(Client.versioned("/%s/domains/%s/ds_records/%s" % [account_id, domain_id, ds_record_id]), options)

        Dnsimple::Response.new(response, Struct::DelegationSignerRecord.new(response["data"]))
      end

      # Deletes a delegation signer record for the domain.
      #
      # WARNING: this cannot be undone.
      #
      # @see https://developer.dnsimple.com/v2/domains/dnssec/#ds-record-delete
      #
      # @param  [Integer] account_id the account ID
      # @param  [#to_s] domain_id The domain ID or domain name
      # @param  [#to_s] ds_record_id The delegation signer record ID
      # @param  [Hash] options
      # @return [Dnsimple::Response<nil>]
      #
      # @raise  [Dnsimple::NotFoundError]
      # @raise  [Dnsimple::RequestError]
      def delete_delegation_signer_record(account_id, domain_id, ds_record_id, options = {})
        response = client.delete(Client.versioned("/%s/domains/%s/ds_records/%s" % [account_id, domain_id, ds_record_id]), nil, options)

        Dnsimple::Response.new(response, nil)
      end

    end
  end
end
