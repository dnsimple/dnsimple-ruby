require 'dnsimple/client/domains_main'
require 'dnsimple/client/domains_records'
require 'dnsimple/client/domains_autorenewals'
require 'dnsimple/client/domains_privacy'
require 'dnsimple/client/domains_sharing'
require 'dnsimple/client/domains_forwards'
require 'dnsimple/client/domains_zones'

module Dnsimple
  class Client
    class DomainsService < ClientService
      include DomainsMain
      include DomainsRecords
      include DomainsAutorenewals
      include DomainsPrivacy
      include DomainsSharing
      include DomainsForwards
      include DomainsZones
    end
  end
end
