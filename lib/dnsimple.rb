require 'httparty'

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

require 'dnsimple/default'
require 'dnsimple/client'
require 'dnsimple/error'
require 'dnsimple/base'
require 'dnsimple/user'
require 'dnsimple/contact'
require 'dnsimple/domain'
require 'dnsimple/email_forward'
require 'dnsimple/record'
require 'dnsimple/template'
require 'dnsimple/template_record'
require 'dnsimple/transfer_order'
require 'dnsimple/extended_attribute'
require 'dnsimple/service'
require 'dnsimple/certificate'
