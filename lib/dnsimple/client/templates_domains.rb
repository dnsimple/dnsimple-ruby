module Dnsimple
  class Client
    module TemplatesDomains

      # Applies the template to the domain.
      #
      # @see http://developer.dnsimple.com/templates/#apply
      #
      # @param  [#to_s] domain The domain id or domain name.
      # @param  [#to_s] template The template id or short-name.
      #
      # @return [void]
      # @raise  [NotFoundError]
      # @raise  [RequestError] When the request fails.
      def apply_template(domain, template)
        response = client.post("v1/domains/#{domain}/templates/#{template}/apply")
        response.code == 200
      end
      alias :apply :apply_template

    end
  end
end
