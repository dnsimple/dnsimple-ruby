# frozen_string_literal: true

module Dnsimple
  module Struct
    class TransferLock < Base

      # @return [Boolean] True if Transfer Lock is enabled on the domain, otherwise false
      attr_accessor :enabled

    end
  end
end
