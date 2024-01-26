# frozen_string_literal: true

module Dnsimple
  module Struct
    class Base

      def initialize(attributes = {})
        attributes.each do |key, value|
          m = :"#{key}="
          send(m, value) if respond_to?(m)
        end
      end

    end
  end
end

require_relative 'struct/account'
require_relative 'struct/collaborator'
require_relative 'struct/contact'
require_relative 'struct/certificate'
require_relative 'struct/certificate_bundle'
require_relative 'struct/certificate_purchase'
require_relative 'struct/certificate_renewal'
require_relative 'struct/charge'
require_relative 'struct/delegation_signer_record'
require_relative 'struct/dnssec'
require_relative 'struct/domain'
require_relative 'struct/domain_check'
require_relative 'struct/domain_premium_price'
require_relative 'struct/domain_price'
require_relative 'struct/domain_push'
require_relative 'struct/domain_registration'
require_relative 'struct/domain_transfer'
require_relative 'struct/domain_renewal'
require_relative 'struct/dns_analytics'
require_relative 'struct/email_forward'
require_relative 'struct/extended_attribute'
require_relative 'struct/oauth_token'
require_relative 'struct/registrant_change_check'
require_relative 'struct/registrant_change'
require_relative 'struct/transfer_lock'
require_relative 'struct/zone_record'
require_relative 'struct/service'
require_relative 'struct/template'
require_relative 'struct/template_record'
require_relative 'struct/tld'
require_relative 'struct/user'
require_relative 'struct/vanity_name_server'
require_relative 'struct/whois_privacy'
require_relative 'struct/whois_privacy_renewal'
require_relative 'struct/zone'
require_relative 'struct/zone_file'
require_relative 'struct/zone_distribution'
require_relative 'struct/webhook'
require_relative 'struct/whoami'
