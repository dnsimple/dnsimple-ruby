module Dnsimple
  class Client

    class Service < Struct.new(:client)
      private

      def validate_mandatory_attributes(attributes, required)
        required.each do |name|
          attributes.key?(name) or raise(ArgumentError, ":#{name} is required")
        end
      end
    end

  end
end
