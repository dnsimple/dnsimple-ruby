module Dnsimple
  module Extra

    # Validates the presence of mandatory attributes.
    #
    # @param  [Hash] attributes
    # @param  [Array<Symbol>] required
    # @return [void]
    # @raise  [ArgumentError]
    def self.validate_mandatory_attributes(attributes, required)
      required.each do |name|
        attributes.key?(name) or raise(ArgumentError, ":#{name} is required")
      end
    end

  end
end
