module Dnsimple
  class Client
    module Oauth

      # Exchange the short-lived authorization code for an access token
      # you can use to authenticate your API calls.
      #
      # @see https://developer.dnsimple.com/v2/oauth/
      #
      # @param  client_id [String] Client Id you received when the application was registered with DNSimple.
      # @param  client_secret [String] Client Secret you received when the application was registered with DNSimple.
      # @option options [String] :redirect_uri The redirect URL sent for the authorization, used to validate the request.
      # @return [String] The url to redirect the user to authorize.
      def exchange_authorization_for_token(code, client_id, client_secret, state = nil, options = {})
        attributes = { code: code, client_id: client_id, client_secret: client_secret, grant_type: "authorization_code" }
        attributes[:state] = state if state
        response = client.post(Client.versioned("/oauth/access_token"), attributes, options)
        Struct::OauthToken.new(response)
      end

      # Gets the URL to authorize an user for an application via the OAuth2 flow.
      #
      # @see https://developer.dnsimple.com/v2/oauth/
      #
      # @param  client_id [String] Client Id you received when the application was registered with DNSimple.
      # @option options [String] :redirect_uri The URL to redirect to after authorizing.
      # @option options [String] :scope The scopes to request from the user.
      # @option options [String] :state A random string to protect against CSRF.
      # @return [String] The URL to redirect the user to authorize.
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
