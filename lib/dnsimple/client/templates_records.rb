module Dnsimple
  class Client
    module TemplatesRecords

      # Lists the records in the template.
      #
      # @see https://developer.dnsimple.com/v2/templates/records/#list
      # @see #all_records
      #
      # @example List the first page of records for the template "alpha"
      #   client.templates.records(1010, "alpha")
      #
      # @example List records for the template "alpha", providing a specific page
      #   client.templates.records(1010, "alpha", query: { page: 2 })
      #
      # @param  [Fixnum, Dnsimple::Client::WILDCARD_ACCOUNT] account_id the account ID or wildcard
      # @param  [String] template_id the template name
      # @param  [Hash] options
      # @return [Dnsimple::PaginatedResponse<Dnsimple::Struct::TemplateRecord>]
      #
      # @raise  [Dnsimple::RequestError]
      def records(account_id, template_id, options = {})
        endpoint = Client.versioned("/%s/templates/%s/records" % [account_id, template_id])
        response = client.get(endpoint, options)

        Dnsimple::PaginatedResponse.new(response, response["data"].map { |r| Struct::TemplateRecord.new(r) })
      end
      alias list_records records

      # Lists ALL the records in the template.
      #
      # This method is similar to {#records}, but instead of returning the results of a specific page
      # it iterates all the pages and returns the entire collection.
      #
      # Please use this method carefully, as fetching the entire collection will increase the number of requests
      # you send to the API server and you may eventually risk to hit the throttle limit.
      #
      # @see https://developer.dnsimple.com/v2/templates/records/#list
      # @see #all_records
      #
      # @param  [Fixnum, Dnsimple::Client::WILDCARD_ACCOUNT] account_id the account ID or wildcard
      # @param  [String] template_id the template name
      # @param  [Hash] options
      # @return [Dnsimple::CollectionResponse<Dnsimple::Struct::TemplateRecord>]
      #
      # @raise  [Dnsimple::RequestError]
      def all_records(account_id, template_id, options = {})
        paginate(:records, account_id, template_id, options)
      end

      # Creates a record in the template.
      #
      # @see https://developer.dnsimple.com/v2/templates/records/#create
      #
      # @param  [Fixnum, Dnsimple::Client::WILDCARD_ACCOUNT] account_id the account ID or wildcard
      # @param  [String] template_id the template name
      # @param  [Hash] attributes
      # @param  [Hash] options
      # @return [Dnsimple::Response<Dnsimple::Struct::TemplateRecord>]
      #
      # @raise  [Dnsimple::RequestError]
      def create_record(account_id, template_id, attributes, options = {})
        endpoint = Client.versioned("/%s/templates/%s/records" % [account_id, template_id])
        response = client.post(endpoint, attributes, options)

        Dnsimple::Response.new(response, Struct::TemplateRecord.new(response["data"]))
      end

      # Gets a record from the template.
      #
      # @see https://developer.dnsimple.com/v2/templates/records/#get
      #
      # @param  [Fixnum, Dnsimple::Client::WILDCARD_ACCOUNT] account_id the account ID or wildcard
      # @param  [String] template_id the template name
      # @param  [Fixnum] record_id the record ID
      # @param  [Hash] options
      # @return [Dnsimple::Response<Dnsimple::Struct::TemplateRecord>]
      #
      # @raise  [Dnsimple::NotFoundError]
      # @raise  [Dnsimple::RequestError]
      def record(account_id, template_id, record_id, options = {})
        endpoint = Client.versioned("/%s/templates/%s/records/%s" % [account_id, template_id, record_id])
        response = client.get(endpoint, options)

        Dnsimple::Response.new(response, Struct::TemplateRecord.new(response["data"]))
      end
    end
  end
end
