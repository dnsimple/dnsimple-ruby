# frozen_string_literal: true

module Dnsimple
  module Struct

    class TemplateRecord < Base
      # @return [Integer] The template record ID in DNSimple.
      attr_accessor :id

      # @return [Integer] The template ID in DNSimple.
      attr_accessor :template_id

      # @return [String] The type of template record, in uppercase.
      attr_accessor :type

      # @return [String] The template record name (without the domain name).
      attr_accessor :name

      # @return [String] The plain-text template record content.
      attr_accessor :content

      # @return [Integer] The template record TTL value.
      attr_accessor :ttl

      # @return [Integer] The priority value, if the type of template record accepts a priority.
      attr_accessor :priority

      # @return [String] When the template record was created in DNSimple.
      attr_accessor :created_at

      # @return [String] When the template record was last updated in DNSimple.
      attr_accessor :updated_at
    end

  end
end
