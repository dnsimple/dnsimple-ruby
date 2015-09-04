module Dnsimple
  class Client
    module Templates

      # Lists the templates in the account.
      #
      # @see http://developer.dnsimple.com/templates/#list
      #
      # @return [Array<Struct::Template>]
      # @raise  [RequestError] When the request fails.
      def templates
        response = client.get("v1/templates")

        response.map { |r| Struct::Template.new(r["dns_template"]) }
      end
      alias :list :templates
      alias :list_templates :templates

      # Creates a template in the account.
      #
      # @see http://developer.dnsimple.com/templates/#create
      #
      # @param  [Hash] attributes
      #
      # @return [Struct::Template]
      # @raise  [RequestError] When the request fails.
      def create_template(attributes = {})
        Extra.validate_mandatory_attributes(attributes, [:name, :short_name])
        options  = { dns_template: attributes }
        response = client.post("v1/templates", options)

        Struct::Template.new(response["dns_template"])
      end
      alias :create :create_template

      # Gets a template from the account.
      #
      # @see http://developer.dnsimple.com/templates/#get
      #
      # @param  [#to_s] template The template id or short-name.
      #
      # @return [Struct::Template]
      # @raise  [NotFoundError]
      # @raise  [RequestError] When the request fails.
      def template(template)
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
      # @raise  [NotFoundError]
      # @raise  [RequestError] When the request fails.
      def update_template(template, attributes = {})
        options  = { dns_template: attributes }
        response = client.put("v1/templates/#{template}", options)

        Struct::Template.new(response["dns_template"])
      end
      alias :update :update_template

      # Deletes a template from the account.
      #
      # WARNING: this cannot be undone.
      #
      # @see http://developer.dnsimple.com/templates/#delete
      #
      # @param  [#to_s] template The template id or short-name.
      #
      # @return [void]
      # @raise  [NotFoundError]
      # @raise  [RequestError] When the request fails.
      def delete_template(template)
        client.delete("v1/templates/#{template}")
      end
      alias :delete :delete_template

    end
  end
end
