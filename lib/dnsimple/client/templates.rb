module Dnsimple
  class Client
    module Templates

      # Lists the templates in the account.
      #
      # @see http://developer.dnsimple.com/v1/templates/#list
      #
      # @return [Array<Struct::Template>]
      #
      # @raise  [RequestError] When the request fails.
      def templates(options = {})
        response = client.get(Client.versioned("templates"), options)

        response.map { |r| Struct::Template.new(r["dns_template"]) }
      end
      alias :list :templates
      alias :list_templates :templates

      # Creates a template in the account.
      #
      # @see http://developer.dnsimple.com/v1/templates/#create
      #
      # @param  [Hash] attributes
      # @return [Struct::Template]
      #
      # @raise  [RequestError] When the request fails.
      def create_template(attributes = {}, options = {})
        Extra.validate_mandatory_attributes(attributes, [:name, :short_name])
        options  = options.merge({ dns_template: attributes })
        response = client.post(Client.versioned("templates"), options)

        Struct::Template.new(response["dns_template"])
      end
      alias :create :create_template

      # Gets a template from the account.
      #
      # @see http://developer.dnsimple.com/v1/templates/#get
      #
      # @param  [#to_s] template The template id or short-name.
      # @return [Struct::Template]
      #
      # @raise  [NotFoundError]
      # @raise  [RequestError] When the request fails.
      def template(template, options = {})
        response = client.get(Client.versioned("templates/#{template}"), options)

        Struct::Template.new(response["dns_template"])
      end

      # Updates a template in the account.
      #
      # @see http://developer.dnsimple.com/v1/templates/#update
      #
      # @param  [#to_s] template The template id or short-name.
      # @param  [Hash] attributes
      # @return [Struct::Template]
      #
      # @raise  [NotFoundError]
      # @raise  [RequestError] When the request fails.
      def update_template(template, attributes = {}, options = {})
        options  = options.merge({ dns_template: attributes })
        response = client.put(Client.versioned("templates/#{template}"), options)

        Struct::Template.new(response["dns_template"])
      end
      alias :update :update_template

      # Deletes a template from the account.
      #
      # WARNING: this cannot be undone.
      #
      # @see http://developer.dnsimple.com/v1/templates/#delete
      #
      # @param  [#to_s] template The template id or short-name.
      # @return [void]
      #
      # @raise  [NotFoundError]
      # @raise  [RequestError] When the request fails.
      def delete_template(template, options = {})
        client.delete(Client.versioned("templates/#{template}"), options)
      end
      alias :delete :delete_template

    end
  end
end
