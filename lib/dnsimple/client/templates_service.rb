require 'dnsimple/client/templates_records_service'

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

    end
  end
end
