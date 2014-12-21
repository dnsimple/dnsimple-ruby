module Dnsimple
  module Struct

    class Base
      def initialize(attributes = {})
        attributes.each do |key, value|
          m = "#{key}=".to_sym
          self.send(m, value) if self.respond_to?(m)
        end
      end
    end

  end
end

require 'dnsimple/struct/certificate'
require 'dnsimple/struct/contact'
require 'dnsimple/struct/domain'
require 'dnsimple/struct/email_forward'
require 'dnsimple/struct/extended_attribute'
require 'dnsimple/struct/record'
require 'dnsimple/struct/service'
require 'dnsimple/struct/template'
require 'dnsimple/struct/template_record'
require 'dnsimple/struct/transfer_order'
require 'dnsimple/struct/user'
