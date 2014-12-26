require 'dnsimple/client/templates_main'
require 'dnsimple/client/templates_records'

module Dnsimple
  class Client
    class TemplatesService < ClientService
      include TemplatesMain
      include TemplatesRecords
    end
  end
end
