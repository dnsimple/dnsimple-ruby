# frozen_string_literal: true

module Dnsimple
  module Struct

    class Template < Base
      # @return [Integer] The template ID in DNSimple.
      attr_accessor :id

      # @return [Integer] The associated account ID.
      attr_accessor :account_id

      # @return [String] The template name.
      attr_accessor :name

      # @return [String] The string ID for the template.
      attr_accessor :sid

      # @return [String] The template description.
      attr_accessor :description
    end

  end
end
