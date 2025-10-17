# frozen_string_literal: true

module Dnsimple
  # Echoes a deprecation warning message.
  #
  # @param  [String] message The message to display.
  # @return [void]
  #
  # @api internal
  # @private
  def self.deprecate(message = nil)
    message ||= "You are using deprecated behavior which will be removed from the next major or minor release."
    warn("DEPRECATION WARNING: #{message}")
  end
end

require "dnsimple/version"
require "dnsimple/default"
require "dnsimple/client"
require "dnsimple/error"
require "dnsimple/options"
