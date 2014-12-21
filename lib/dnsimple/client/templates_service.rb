module Dnsimple
  class Client
    class TemplatesService < ClientService

      # Lists the templates in the account.
      #
      # @see http://developer.dnsimple.com/templates/#list
      #
      # @return [Array<Struct::Template>]
      # @raise  [RequestError] When the request fails.
      def list
        response = client.get("v1/templates")

        response.map { |r| Struct::Template.new(r["dns_template"]) }
      end

      # Creates a template in the account.
      #
      # @see http://developer.dnsimple.com/templates/#create
      #
      # @param  [Hash] attributes
      #
      # @return [Struct::Template]
      # @raise  [RequestError] When the request fails.
      def create(attributes = {})
        Extra.validate_mandatory_attributes(attributes, [:name, :short_name])
        options  = { dns_template: attributes }
        response = client.post("v1/templates", options)

        Struct::Template.new(response["dns_template"])
      end

      # Gets a template from the account.
      #
      # @see http://developer.dnsimple.com/templates/#get
      #
      # @param  [#to_s] template The template id or short-name.
      #
      # @return [Struct::Template]
      # @raise  [RecordNotFound]
      # @raise  [RequestError] When the request fails.
      def find(template)
        response = client.get("v1/templates/#{template}")

        Struct::Template.new(response["dns_template"])
      end

      # Updates a template in the account.
      #
      # @see http://developer.dnsimple.com/templates/#update
      #
      # @param  [#to_s] template The template id or short-name.
      # @param  [Hash] attributes
      #
      # @return [Struct::Template]
      # @raise  [RecordNotFound]
      # @raise  [RequestError] When the request fails.
      def update(template, attributes = {})
        options  = { dns_template: attributes }
        response = client.put("v1/templates/#{template}", options)

        Struct::Template.new(response["dns_template"])
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


      # Applies the template to the domain.
      #
      # @see http://developer.dnsimple.com/templates/#apply
      #
      # @param  [#to_s] domain The domain id or domain name.
      # @param  [#to_s] template The template id or short-name.
      #
      # @return [void]
      # @raise  [RecordNotFound]
      # @raise  [RequestError] When the request fails.
      def apply(domain, template)
        response = client.post("v1/domains/#{domain}/templates/#{template}/apply")
        response.code == 200
      end


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
