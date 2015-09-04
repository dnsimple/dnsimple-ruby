module Dnsimple
  class Client
    module TemplatesRecords

      # Lists the records for a template.
      #
      # @see http://developer.dnsimple.com/v1/templates/records/#list
      #
      # @param  [#to_s] template The template id or short-name.
      # @return [Array<Struct::TemplateRecord>]
      #
      # @raise  [NotFoundError]
      # @raise  [RequestError] When the request fails.
      def records(template, options = {})
        response = client.get("v1/templates/#{template}/records", options)

        response.map { |r| Struct::TemplateRecord.new(r["dns_template_record"]) }
      end

      # Creates a record for a template.
      #
      # @see http://developer.dnsimple.com/v1/templates/records/#create
      #
      # @param  [#to_s] template The template id or short-name.
      # @param  [Hash] attributes
      # @return [Struct::TemplateRecord]
      #
      # @raise  [NotFoundError]
      # @raise  [RequestError] When the request fails.
      def create_record(template, attributes = {}, options = {})
        Extra.validate_mandatory_attributes(attributes, [:name, :record_type, :content])
        options  = options.merge({ dns_template_record: attributes })
        response = client.post("v1/templates/#{template}/records", options)

        Struct::TemplateRecord.new(response["dns_template_record"])
      end

      # Gets a record for a template.
      #
      # @see http://developer.dnsimple.com/v1/templates/records/#delete
      #
      # @param  [#to_s] template The template id or short-name.
      # @param  [Fixnum] record The record id.
      # @return [Struct::TemplateRecord]
      #
      # @raise  [NotFoundError]
      # @raise  [RequestError] When the request fails.
      def record(template, record, options = {})
        response = client.get("v1/templates/#{template}/records/#{record}", options)

        Struct::TemplateRecord.new(response["dns_template_record"])
      end

      # Updates a record for a template.
      #
      # @see http://developer.dnsimple.com/v1/templates/#update
      #
      # @param  [#to_s] template The template id or short-name.
      # @param  [Fixnum] record The record id.
      # @param  [Hash] attributes
      # @return [Struct::TemplateRecord]
      #
      # @raise  [NotFoundError]
      # @raise  [RequestError] When the request fails.
      def update_record(template, record, attributes = {}, options = {})
        options  = options.merge({ dns_template_record: attributes })
        response = client.put("v1/templates/#{template}/records/#{record}", options)

        Struct::TemplateRecord.new(response["dns_template_record"])
      end

      # Deletes a record for a template.
      #
      # @see http://developer.dnsimple.com/v1/templates/records/#get
      #
      # @param  [#to_s] template The template id or short-name.
      # @param  [Fixnum] record The record id.
      # @return [Template]
      #
      # @raise  [NotFoundError]
      # @raise  [RequestError] When the request fails.
      def delete_record(template, record, options = {})
        client.delete("v1/templates/#{template}/records/#{record}", options)
      end

    end
  end
end
