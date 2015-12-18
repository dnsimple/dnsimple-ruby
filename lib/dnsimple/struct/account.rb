module Dnsimple
  module Struct

    class Account < Base
      # @return [Fixnum] The account ID in DNSimple.
      attr_accessor :id

      # @return [String] The account email.
      attr_accessor :name
    end

  end
end
