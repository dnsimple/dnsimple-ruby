# frozen_string_literal: true

module Dnsimple
  module Struct
    class User < Base

      # @return [Integer] The user ID in DNSimple.
      attr_accessor :id

      # @return [String] The user email.
      attr_accessor :email

    end
  end
end
