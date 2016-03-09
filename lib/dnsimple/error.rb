module Dnsimple

  class Error < StandardError
  end

  # RequestError is raised when an API request fails for an client, a server error or invalid request information.
  class RequestError < Error
    attr_reader :http_response

    def initialize(http_response)
      @http_response = http_response
      super(http_response.code.to_s)
    end
  end

  class NotFoundError < RequestError
  end

  class AuthenticationError < Error
  end

  class AuthenticationFailed < AuthenticationError
  end

end
