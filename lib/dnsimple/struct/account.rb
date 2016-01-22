module Dnsimple
  module Struct

    class Account < Base
      # @return [Fixnum] The account ID in DNSimple.
      attr_accessor :id

      # @return [String] The account email.
      attr_accessor :email
    end

  end
end
