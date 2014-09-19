module DNSimple
  class User < Base

    attr_accessor :id
    attr_accessor :email
    attr_accessor :domain_count
    attr_accessor :domain_limit
    attr_accessor :login_count
    attr_accessor :failed_login_count
    attr_accessor :created_at
    attr_accessor :updated_at


    # Gets the information about the authenticated user.
    #
    # @return [User] the authenticated user
    # @raise  [RequestError] if the user doesn't exist
    def self.me
      response = DNSimple::Client.get("/v1/user")

      case response.code
      when 200
        new(response["user"])
      else
        raise RequestError.new("Error finding account", response)
      end
    end

    # Requests a new two-factor authentication exchange token.
    #
    # The exchange-token is required to validate API requests
    # using HTTP Basic Authentication when the account has two-factor authentication enabled.
    #
    # @see http://developer.dnsimple.com/authentication/#twofa
    #
    # @example Request an Exchange Token
    #
    #   DNSimple::User.two_factor_exchange_token('0000000')
    #   # => "cda038832591e34f5df642ce2b61dc78"
    #
    # @param  [String] otp_token the two-factor one time (OTP) token
    #
    # @return [String] the two-factor API exchange token
    # @raise  [AuthenticationFailed] if the provided OTP token is invalid
    def self.two_factor_exchange_token(otp_token)
      response = DNSimple::Client.get("/v1/user", headers: { DNSimple::Client::HEADER_2FA_STRICT => "1", DNSimple::Client::HEADER_OTP_TOKEN => otp_token })
      response.headers[DNSimple::Client::HEADER_EXCHANGE_TOKEN]
    end

  end
end
