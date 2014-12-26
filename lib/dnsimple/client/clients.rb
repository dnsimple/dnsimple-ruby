module Dnsimple
  class Client

    class ClientService < ::Struct.new(:client)
    end


    require 'dnsimple/client/certificates_main'

    class CertificatesService < ClientService
      include CertificatesMain
    end


    require 'dnsimple/client/contacts_main'

    class ContactsService < ClientService
      include ContactsMain
    end


    require 'dnsimple/client/domains_main'
    require 'dnsimple/client/domains_records'
    require 'dnsimple/client/domains_autorenewals'
    require 'dnsimple/client/domains_privacy'
    require 'dnsimple/client/domains_sharing'
    require 'dnsimple/client/domains_forwards'
    require 'dnsimple/client/domains_zones'

    class DomainsService < ClientService
      include DomainsMain
      include DomainsRecords
      include DomainsAutorenewals
      include DomainsPrivacy
      include DomainsSharing
      include DomainsForwards
      include DomainsZones
    end


    require 'dnsimple/client/name_servers_main'

    class NameServersService < ClientService
      include NameServersMain
    end


    require 'dnsimple/client/registrars_main'

    class RegistrarsService < ClientService
      include RegistrarsMain
    end


    require 'dnsimple/client/services_main'
    require 'dnsimple/client/services_domains'

    class ServicesService < ClientService
      include ServicesMain
      include ServicesDomains
    end


    require 'dnsimple/client/templates_main'
    require 'dnsimple/client/templates_records'

    class TemplatesService < ClientService
      include TemplatesMain
      include TemplatesRecords
    end


    require 'dnsimple/client/users_main'

    class UsersService < ClientService
      include UsersMain
    end

  end
end
