module Dnsimple

  # The PaginatedResponse wraps a standard collection response to expose the information about the pagination.
  #
  # This object behaves as an Array. In fact, it inherits from Array.
  class PaginatedResponse < Array

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
    # @param  [Hash] metadata the content of the "pagination" node in the JSON response
    # @param  [Array] collection the enumerable collection of records returned in the response
    def initialize(response, collection)
      super().concat(collection)

      pagination = response["pagination"]
      @page           = pagination["current_page"]
      @per_page       = pagination["per_page"]
      @total_entries  = pagination["total_entries"]
      @total_pages    = pagination["total_pages"]
    end

  end

end
