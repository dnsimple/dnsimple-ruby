module Dnsimple
  class Client

    # @return [Dnsimple::Client::DomainsService] The domain-related API proxy.
    def domains
      @services[:domains] ||= Client::DomainsService.new(self)
    end

    # @return [Dnsimple::Client::MiscService] The miscellaneous-methods API proxy.
    def misc
      @services[:misc] ||= Client::MiscService.new(self)
    end


    class ClientService < ::Struct.new(:client)
    end


    require_relative 'domains'

    class DomainsService < ClientService
      include Client::Domains
    end


    require_relative 'misc'

    class MiscService < ClientService
      include Client::Misc
    end

  end
end
