module Dnsimple

  class Error < StandardError
  end

  class RequestError < Error
    attr_reader :response

    def initialize(response)
      @response = response
      super("#{response.code}")
    end
  end

  class RecordNotFound < RequestError
  end

  class AuthenticationError < Error
  end

  class AuthenticationFailed < AuthenticationError
  end

  # An exception that is raised if a request is executed for an account that requires two-factor authentication.
  class TwoFactorAuthenticationRequired < AuthenticationError
  end

end
