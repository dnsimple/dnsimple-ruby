module Dnsimple
  module Struct

    class Template < Base
      # @return [Fixnum] The template ID in DNSimple.
      attr_accessor :id

      # @return [String] The template name.
      attr_accessor :name

      # @return [String] The URI-compatible slug.
      attr_accessor :short_name

      # @return [String] The description.
      attr_accessor :description
    end

  end
end
