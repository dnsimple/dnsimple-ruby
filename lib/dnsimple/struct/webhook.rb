module Dnsimple
  module Struct

    class Webhook < Base
      # @return [Integer] The contact ID in DNSimple.
      attr_accessor :id

      # @return [String] The callback URL.
      attr_accessor :url
    end

  end
end
