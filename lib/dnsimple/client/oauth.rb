module Dnsimple
  class Client
    module Oauth

      # Gets the URL to authorize an user for an application via the OAuth2 flow.
      #
      # @see https://developer.dnsimple.com/v2/oauth/
      #
      # @param  client_id [String] Client Id you received when the application was registered with DNSimple.
      # @option options [String] :redirect_uri The url to redirect to after authorizing.
      # @option options [String] :scope The scopes to request from the user.
      # @option options [String] :state A random string to protect against CSRF.
      # @return [String] The url to redirect the user to authorize.
      def authorize_url(client_id, options = {})
        site_url = client.base_url.sub("api.", "")
        url = URI.join(site_url, "/oauth/authorize?client_id=#{client_id}")

        options = options.merge(response_type: "code")
        options.each do |key, value|
          url.query += "&#{key}=#{value}"
        end
        url.to_s
      end

    end
  end
end