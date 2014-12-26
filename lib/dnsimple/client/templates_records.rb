module Dnsimple
  class Client
    module TemplatesRecords

      # Lists the records for a template.
      #
      # @see http://developer.dnsimple.com/templates/records/#list
      #
      # @param  [#to_s] template The template id or short-name.
      #
      # @return [Array<Struct::TemplateRecord>]
      # @raise  [RecordNotFound]
      # @raise  [RequestError] When the request fails.
      def list_records(template)
        response = client.get("v1/templates/#{template}/records")

        response.map { |r| Struct::TemplateRecord.new(r["dns_template_record"]) }
      end

      # Creates a record for a template.
      #
      # @see http://developer.dnsimple.com/templates/records/#create
      #
      # @param  [#to_s] template The template id or short-name.
      # @param  [Hash] attributes
      #
      # @return [Struct::TemplateRecord]
      # @raise  [RecordNotFound]
      # @raise  [RequestError] When the request fails.
      def create_record(template, attributes = {})
        Extra.validate_mandatory_attributes(attributes, [:name, :record_type, :content])
        options  = { dns_template_record: attributes }
        response = client.post("v1/templates/#{template}/records", options)

        Struct::TemplateRecord.new(response["dns_template_record"])
      end

      # Gets a record for a template.
      #
      # @see http://developer.dnsimple.com/templates/records/#delete
      #
      # @param  [#to_s] template The template id or short-name.
      # @param  [Fixnum] record The record id.
      #
      # @return [Struct::TemplateRecord]
      # @raise  [RecordNotFound]
      # @raise  [RequestError] When the request fails.
      def find_record(template, record)
        response = client.get("v1/templates/#{template}/records/#{record}")

        Struct::TemplateRecord.new(response["dns_template_record"])
      end

      # Updates a record for a template.
      #
      # @see http://developer.dnsimple.com/templates/#update
      #
      # @param  [#to_s] template The template id or short-name.
      # @param  [Fixnum] record The record id.
      # @param  [Hash] attributes
      #
      # @return [Struct::TemplateRecord]
      # @raise  [RecordNotFound]
      # @raise  [RequestError] When the request fails.
      def update_record(template, record, attributes = {})
        options  = { dns_template_record: attributes }
        response = client.put("v1/templates/#{template}/records/#{record}", options)

        Struct::TemplateRecord.new(response["dns_template_record"])
      end

      # Deletes a record for a template.
      #
      # @see http://developer.dnsimple.com/templates/records/#get
      #
      # @param  [#to_s] template The template id or short-name.
      # @param  [Fixnum] record The record id.
      #
      # @return [Template]
      # @raise  [RecordNotFound]
      # @raise  [RequestError] When the request fails.
      def delete_record(template, record)
        client.delete("v1/templates/#{template}/records/#{record}")
      end

    end
  end
end
