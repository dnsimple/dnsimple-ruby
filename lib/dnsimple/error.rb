# frozen_string_literal: true

module Dnsimple

  class Error < StandardError
  end

  # RequestError is raised when an API request fails for an client, a server error or invalid request information.
  class RequestError < Error
    attr_reader :http_response

    def initialize(http_response)
      @http_response = http_response
      super(message_from(http_response))
    end

    private

    def message_from(http_response)
      content_type = http_response.headers["Content-Type"]
      if content_type&.start_with?("application/json")
        http_response.parsed_response["message"]
      else
        net_http_response = http_response.response
        "#{net_http_response.code} #{net_http_response.message}"
      end
    end

  end

  class NotFoundError < RequestError
  end

  class AuthenticationError < Error
  end

  class AuthenticationFailed < AuthenticationError
  end

end
