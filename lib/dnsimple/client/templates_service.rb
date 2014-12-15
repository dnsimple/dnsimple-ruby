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

    end
  end
end
