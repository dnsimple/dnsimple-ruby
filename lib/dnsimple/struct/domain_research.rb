# frozen_string_literal: true

module Dnsimple
  module Struct
    class DomainResearch < Base
      # @return [String] UUID identifier for this research request.
      attr_accessor :request_id

      # @return [String] The domain name that was researched.
      attr_accessor :domain

      # @return [String] The availability status. Possible values: available, unavailable, unknown
      attr_accessor :availability

      # @return [Array<String>] Array of error messages if the domain cannot be researched.
      attr_accessor :errors
    end
  end
end
