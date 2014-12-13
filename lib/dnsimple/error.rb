module Dnsimple

  class Error < StandardError
  end

  class RecordExists < Error
  end

  class RecordNotFound < Error
  end

  # An exception that is raised if a method is called with missing or invalid parameter values.
  class ValidationError < Error
  end

  class RequestError < Error
    def initialize(description, response)
      super("#{description}: #{response["error"]}")
    end
  end

  class AuthenticationError < Error
  end

  class AuthenticationFailed < AuthenticationError
  end

  # An exception that is raised if a request is executed for an account that requires two-factor authentication.
  class TwoFactorAuthenticationRequired < AuthenticationError
  end

end
