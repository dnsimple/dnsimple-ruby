# frozen_string_literal: true

module Dnsimple

  class Error < StandardError
  end

  # RequestError is raised when an API request fails for an client, a server error or invalid request information.
  class RequestError < Error
    attr_reader :http_response, :attribute_errors

    def initialize(http_response)
      @http_response = http_response
      @attribute_errors = attribute_errors_from(http_response)
      super(message_from(http_response))
    end

    private

    def attribute_errors_from(http_response)
      return unless is_json_response?(http_response)

      http_response.parsed_response["errors"]
    end

    def message_from(http_response)
      if is_json_response?(http_response)
        http_response.parsed_response["message"]
      else
        net_http_response = http_response.response
        "#{net_http_response.code} #{net_http_response.message}"
      end
    end

    def is_json_response?(http_response)
      content_type = http_response.headers["Content-Type"]
      content_type&.start_with?("application/json")
    end

  end

  class NotFoundError < RequestError
  end

  class AuthenticationError < Error
  end

  class AuthenticationFailed < AuthenticationError
  end

  class OAuthInvalidRequestError < Error
    attr_reader :http_response, :error, :error_description

    def initialize(http_response)
      @http_response = http_response
      @error = http_response.parsed_response["error"]
      @error_description = http_response.parsed_response["error_description"]
      super(message)
    end

    private

    def message
      "#{error}: #{error_description}"
    end
  end

end
