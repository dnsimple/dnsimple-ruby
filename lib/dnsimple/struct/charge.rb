# frozen_string_literal: true

require "bigdecimal"

module Dnsimple
  module Struct
    class Charge < Base
      class ChargeItem < Base
        # @return [String] The description of the charge item.
        attr_accessor :description

        # @return [Float] The amount of the charge item.
        attr_reader :amount

        # @return [Integer] The ID of the product that was charged.
        attr_accessor :product_id

        # @return [String] The type of the product that was charged.
        attr_accessor :product_type

        # @return [String] A unique or representative reference.
        attr_accessor :product_reference

        # Converts amount to a Float and sets it.
        #
        # @param  [String] amount
        # @return [void]
        def amount=(amount)
          @amount = BigDecimal(amount)
        end
      end

      # @return [String] The reference number of the invoice.
      attr_accessor :reference

      # @return [Float] The aggregate amount of all line items, that need to be paid.
      attr_reader :total_amount

      # @return [Float] The amount that was paid via wallet.
      attr_reader :balance_amount

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

      # Converts items to an Array<Struct::Charge::ChargeItem> and sets it.
      #
      # @param  [Array<Hash>] charge_items
      # @return [void]
      def items=(charge_items)
        @items = charge_items.map do |charge_item|
          Charge::ChargeItem.new(charge_item)
        end
      end

      # Converts balance_amount to a Float and sets it.
      #
      # @param  [String] balance_amount
      # @return [void]
      def balance_amount=(balance_amount)
        @balance_amount = BigDecimal(balance_amount)
      end

      # Converts total_amount to a Float and sets it.
      #
      # @param  [String] total_amount
      # @return [void]
      def total_amount=(total_amount)
        @total_amount = BigDecimal(total_amount)
      end
    end
  end
end
