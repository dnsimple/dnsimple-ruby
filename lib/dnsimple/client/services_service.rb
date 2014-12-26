require 'dnsimple/client/services_main'
require 'dnsimple/client/services_domains'

module Dnsimple
  class Client
    class ServicesService < ClientService
      include ServicesMain
      include ServicesDomains
    end
  end
end
