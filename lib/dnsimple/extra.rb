# frozen_string_literal: true

module Dnsimple
  module Extra

    # Joins two pieces of URI with a /.
    #
    # @return [String] The joined string.
    def self.join_uri(*parts)
      parts.map { |part| part.chomp("/") }.join("/")
    end

    # Returns a new hash with +self+ and +other+ merged recursively.
    #
    #   h1 = { a: true, b: { c: [1, 2, 3] } }
    #   h2 = { a: false, b: { x: [3, 4, 5] } }
    #
    #   Extra.deep_merge(h1, h2) #=> { a: false, b: { c: [1, 2, 3], x: [3, 4, 5] } }
    #
    # Like with Hash#merge in the standard library, a block can be provided
    # to merge values:
    #
    #   h1 = { a: 100, b: 200, c: { c1: 100 } }
    #   h2 = { b: 250, c: { c1: 200 } }
    #   Extra.deep_merge(h1, h2) { |key, this_val, other_val| this_val + other_val }
    #   # => { a: 100, b: 450, c: { c1: 300 } }
    def self.deep_merge(this, other, &block)
      deep_merge!(this.dup, other, &block)
    end

    # Same as +deep_merge+, but modifies +this+ instead of returning a new hash.
    def self.deep_merge!(this, other, &block)
      other.each_pair do |current_key, other_value|
        this_value = this[current_key]

        this[current_key] = if this_value.is_a?(Hash) && other_value.is_a?(Hash)
          deep_merge(this_value, other_value, &block)
        else
          if block && key?(current_key)
            yield(current_key, this_value, other_value)
          else
            other_value
          end
        end
      end

      this
    end

    # Validates the presence of mandatory attributes.
    #
    # @param  [Hash] attributes
    # @param  [Array<Symbol>] required
    # @return [void]
    # @raise  [ArgumentError]
    def self.validate_mandatory_attributes(attributes, required)
      required.each do |name|
        attributes&.key?(name) or raise(ArgumentError, ":#{name} is required")
      end
    end

  end
end
