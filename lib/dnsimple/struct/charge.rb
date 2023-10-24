# frozen_string_literal: true

module Dnsimple
  module Struct
    class Charge < Base

      class ChargeItem < Base
        # @return [String] The description of the charge item.
        attr_accessor :description

        # @return [String] The amount of the charge item.
        attr_accessor :amount

        # @return [Integer] The ID of the product that was charged.
        attr_accessor :product_id

        # @return [String] The type of the product that was charged.
        attr_accessor :product_type

        # @return [String] A unique or representative reference.
        attr_accessor :product_reference
      end

      # @return [String] The reference number of the invoice.
      attr_accessor :reference

      # @return [String] The aggregate amount of all line items, that need to be paid.
      attr_accessor :total_amount

      # @return [String] The amount that was paid via wallet.
      attr_accessor :balance_amount

      # @return [String] The state of the charge.
      attr_accessor :state

      # @return [DateTime] When the charge was invoiced.
      attr_accessor :invoiced_at

      # @return [Array<ChargeItems>] The charge items.
      attr_reader :items

      def initialize(*)
        super
        @items ||= []
      end

      def items=(charge_items)
        @items = charge_items.map do |charge_item|
          Charge::ChargeItem.new(charge_item)
        end
      end
    end

  end
end
