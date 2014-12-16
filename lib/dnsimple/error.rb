module Dnsimple

  class Error < StandardError
  end

  class RequestError < Error
    attr_reader :response

    def initialize(*args)
      if args.size == 2
        message, @response = *args
        super("#{message}: #{response["error"]}")
      else
        @response = args.first
        super("#{response.code}")
      end
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
