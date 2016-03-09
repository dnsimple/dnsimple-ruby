module Dnsimple

  # The Response represents a response returned by a client request.
  #
  # It wraps the content of the response data, as well other response metadata such as rate-limiting information.
  class Response

    # @return [HTTParty::Response]
    attr_reader :http_response

    # @return [Struct::Base, Array] The content of the response data field.
    attr_reader :data

    # @return [Fixnum] The maximum number of requests this authentication context can perform per hour.
    # @see https://developer.dnsimple.com/v2/#rate-limiting
    attr_reader :rate_limit

    # @return [Fixnum] The number of requests remaining in the current rate limit window.
    # @see https://developer.dnsimple.com/v2/#rate-limiting
    attr_reader :rate_limit_remaining

    # @return [Fixnum] The time at which the current rate limit window in Unix time format.
    # @see https://developer.dnsimple.com/v2/#rate-limiting
    attr_reader :rate_limit_reset


    # @param  [HTTParty::Response] http_response the HTTP response
    # @param  [Object] data the response data
    def initialize(http_response, data)
      @http_response = http_response
      @data = data

      @rate_limit = http_response.headers['X-RateLimit-Limit'].to_i
      @rate_limit_remaining = http_response.headers['X-RateLimit-Remaining'].to_i
      @rate_limit_reset = Time.at(http_response.headers['X-RateLimit-Reset'].to_i)
    end

  end

  # The CollectionResponse is a specific type of Response where the data is a collection of enumerable objects.
  class CollectionResponse < Response
    def initialize(http_response, collection)
      super
    end
  end

  # The PaginatedResponse is a specific type of Response that also exposes pagination metadata.
  class PaginatedResponse < CollectionResponse

    # @return [Fixnum] The current page.
    attr_reader :page

    # @return [Fixnum] The number of records per page.
    attr_reader :per_page

    # @return [Fixnum] The total number of records.
    attr_reader :total_entries

    # @return [Fixnum] The total number of pages.
    attr_reader :total_pages


    # Initializes a new paginated response from the response metadata,
    # and with given collection.
    #
    # @param  [Hash] http_response the HTTP response
    # @param  [Array] collection the enumerable collection of records returned in the response data
    def initialize(http_response, collection)
      super

      pagination = http_response["pagination"]
      @page           = pagination["current_page"]
      @per_page       = pagination["per_page"]
      @total_entries  = pagination["total_entries"]
      @total_pages    = pagination["total_pages"]
    end

  end

end
