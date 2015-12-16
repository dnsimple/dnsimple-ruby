module Dnsimple
  class Client

    # @return [Dnsimple::Client::DomainsService] The domain-related API proxy.
    def domains
      @services[:domains] ||= Client::DomainsService.new(self)
    end


    class ClientService < ::Struct.new(:client)
    end


    require_relative 'domains'

    class DomainsService < ClientService
      include Client::Domains
    end

  end
end
