require 'pp'
require 'httparty'

module DNSimple
  BLANK_REGEX = /\S+/
end

require 'dnsimple/client'
require 'dnsimple/error'
require 'dnsimple/user'
require 'dnsimple/contact'
require 'dnsimple/domain'
require 'dnsimple/record'
require 'dnsimple/template'
require 'dnsimple/template_record'
require 'dnsimple/transfer_order'
require 'dnsimple/extended_attribute'
require 'dnsimple/service'
require 'dnsimple/certificate'
