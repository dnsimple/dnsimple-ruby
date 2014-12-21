module Dnsimple
  class Client
    class UsersService < ClientService

      # Fetches the information about the authenticated user.
      #
      # @return [Struct::User] The authenticated user.
      # @raise  [RequestError] When the request fails.
      def user
        response = client.get("v1/user")

        Struct::User.new(response["user"])
      end

      # Requests a new two-factor authentication exchange token.
      #
      # The exchange-token is required to validate API requests
      # using HTTP Basic Authentication when the account has two-factor authentication enabled.
      #
      # @see http://developer.dnsimple.com/authentication/#twofa
      #
      # @example Request an Exchange Token
      #   Dnsimple::User.two_factor_exchange_token('0000000')
      #   # => "cda038832591e34f5df642ce2b61dc78"
      #
      # @param  [String] otp_token the two-factor one time (OTP) token.
      #
      # @return [String] The two-factor API exchange token.
      # @raise  [AuthenticationFailed] if the provided OTP token is invalid.
      def exchange_token(otp_token)
        response = client.get("v1/user", headers: { Client::HEADER_2FA_STRICT => "1", Client::HEADER_OTP_TOKEN => otp_token })
        response.headers[Client::HEADER_EXCHANGE_TOKEN]
      end

    end
  end
end
