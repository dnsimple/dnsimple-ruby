module Dnsimple
  module Struct

    class User < Base
      # @return [Fixnum] The user ID in DNSimple.
      attr_accessor :id

      # @return [String] The user email.
      attr_accessor :name
    end

  end
end
