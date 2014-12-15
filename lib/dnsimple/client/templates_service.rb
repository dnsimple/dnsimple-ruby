module Dnsimple
  class Client
    class TemplatesService < ClientService

      # Lists the templates in the account.
      #
      # @see http://developer.dnsimple.com/templates/#list
      #
      # @return [Array<Template>]
      # @raise  [RequestError] When the request fails.
      def list
        response = client.get("v1/templates")

        response.map { |r| Template.new(r["dns_template"]) }
      end

      # Creates a template in the account.
      #
      # @see http://developer.dnsimple.com/templates/#create
      #
      # @param  [Hash] attributes
      #
      # @return [Template]
      # @raise  [RequestError] When the request fails.
      def create(attributes = {})
        validate_mandatory_attributes(attributes, [:name, :short_name])
        options  = { body: { dns_template: attributes }}
        response = client.post("v1/templates", options)

        Template.new(response["dns_template"])
      end

      # Gets a template from the account.
      #
      # @see http://developer.dnsimple.com/templates/#get
      #
      # @param  [#to_s] template The template id or short-name.
      #
      # @return [Template]
      # @raise  [RecordNotFound]
      # @raise  [RequestError] When the request fails.
      def find(template)
        response = client.get("v1/templates/#{template}")

        Template.new(response["dns_template"])
      end

      # Updates a template in the account.
      #
      # @see http://developer.dnsimple.com/templates/#update
      #
      # @param  [#to_s] template The template id or short-name.
      # @param  [Hash] attributes
      #
      # @return [Template]
      # @raise  [RecordNotFound]
      # @raise  [RequestError] When the request fails.
      def update(template, attributes = {})
        options  = { body: { dns_template: attributes }}
        response = client.put("v1/templates/#{template}", options)

        Template.new(response["dns_template"])
      end

      # Deletes a template from the account.
      #
      # WARNING: this cannot be undone.
      #
      # @see http://developer.dnsimple.com/templates/#delete
      #
      # @param  [#to_s] template The template id or short-name.
      #
      # @return [void]
      # @raise  [RecordNotFound]
      # @raise  [RequestError] When the request fails.
      def delete(template)
        client.delete("v1/templates/#{template}")
      end


      # Lists the records for a template.
      #
      # @see http://developer.dnsimple.com/templates/records/#list
      #
      # @param  [#to_s] template The template id or short-name.
      #
      # @return [Array<TemplateRecord>]
      # @raise  [RecordNotFound]
      # @raise  [RequestError] When the request fails.
      def list_records(template)
        response = client.get("v1/templates/#{template}/records")

        response.map { |r| TemplateRecord.new(r["dns_template_record"]) }
      end

      # Creates a record for a template.
      #
      # @see http://developer.dnsimple.com/templates/records/#create
      #
      # @param  [#to_s] template The template id or short-name.
      # @param  [Hash] attributes
      #
      # @return [Record]
      # @raise  [RecordNotFound]
      # @raise  [RequestError] When the request fails.
      def create_record(domain, attributes = {})
        validate_mandatory_attributes(attributes, [:name, :record_type, :content])
        options  = { body: { dns_template_record: attributes }}
        response = client.post("v1/templates/#{domain}/records", options)

        TemplateRecord.new(response["dns_template_record"])
      end

      # Gets a record for a template.
      #
      # @see http://developer.dnsimple.com/templates/records/#delete
      #
      # @param  [#to_s] template The template id or short-name.
      # @param  [Fixnum] record The record id.
      #
      # @return [TemplateRecord]
      # @raise  [RecordNotFound]
      # @raise  [RequestError] When the request fails.
      def find_record(template, record)
        response = client.get("v1/templates/#{template}/records/#{record}")

        TemplateRecord.new(response["dns_template_record"])
      end

      # Updates a record for a template.
      #
      # @see http://developer.dnsimple.com/templates/#update
      #
      # @param  [#to_s] template The template id or short-name.
      # @param  [Fixnum] record The record id.
      # @param  [Hash] attributes
      #
      # @return [TemplateRecord]
      # @raise  [RecordNotFound]
      # @raise  [RequestError] When the request fails.
      def update_record(template, record, attributes = {})
        options  = { body: { dns_template_record: attributes }}
        response = client.put("v1/templates/#{template}/records/#{record}", options)

        TemplateRecord.new(response["dns_template_record"])
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
