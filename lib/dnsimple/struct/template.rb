module Dnsimple
  module Struct

    class Template < Base
      # @return [Fixnum] The template ID in DNSimple.
      attr_accessor :id

      # @return [Fixnum] The associated account ID.
      attr_accessor :account_id

      # @return [String] The template name.
      attr_accessor :name

      # @return [String] The short name for the template.
      attr_accessor :short_name

      # @return [String] The template description.
      attr_accessor :description
    end

  end
end
