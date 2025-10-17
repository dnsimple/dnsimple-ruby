# frozen_string_literal: true

module Dnsimple
  module Struct
    class DomainPremiumPrice < Base
      # @return [String] The domain premium price
      attr_accessor :premium_price

      # @return [String] The action: registration/transfer/renewal
      attr_accessor :action
    end
  end
end
