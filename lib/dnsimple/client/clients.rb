module Dnsimple
  class Client

    # @return [Dnsimple::Client::CertificatesService] The certificate-related API proxy.
    def certificates
      @services[:certificates] ||= Client::CertificatesService.new(self)
    end

    # @return [Dnsimple::Client::ContactsService] The contact-related API proxy.
    def contacts
      @services[:contacts] ||= Client::ContactsService.new(self)
    end

    # @return [Dnsimple::Client::DomainsService] The domain-related API proxy.
    def domains
      @services[:domains] ||= Client::DomainsService.new(self)
    end

    # @return [Dnsimple::Client::NameServersService] The name server-related API proxy.
    def name_servers
      @services[:name_servers] ||= Client::NameServersService.new(self)
    end

    # @return [Dnsimple::Client::VanityNameServersService] The vanity name server-related API proxy.
    def vanity_name_servers
      @services[:vanity_name_servers] ||= Client::VanityNameServersService.new(self)
    end

    # @return [Dnsimple::Client::RegistrarService] The registrar-related API proxy.
    def registrar
      @services[:registrar] ||= Client::RegistrarService.new(self)
    end

    # @return [Dnsimple::Client::ServicesService] The service-related API proxy.
    def services
      @services[:services] ||= Client::ServicesService.new(self)
    end

    # @return [Dnsimple::Client::TemplatesService] The template-related API proxy.
    def templates
      @services[:templates] ||= Client::TemplatesService.new(self)
    end

    # @return [Dnsimple::Client::UsersService] The user-related API proxy.
    def users
      @services[:users] ||= Client::UsersService.new(self)
    end


    class ClientService < ::Struct.new(:client)
    end


    require 'dnsimple/client/certificates'

    class CertificatesService < ClientService
      include Client::Certificates
    end


    require 'dnsimple/client/contacts'

    class ContactsService < ClientService
      include Client::Contacts
    end


    require 'dnsimple/client/domains'
    require 'dnsimple/client/domains_records'
    require 'dnsimple/client/domains_autorenewals'
    require 'dnsimple/client/domains_privacy'
    require 'dnsimple/client/domains_sharing'
    require 'dnsimple/client/domains_forwards'
    require 'dnsimple/client/domains_zones'

    class DomainsService < ClientService
      include Client::Domains
      include Client::DomainsRecords
      include Client::DomainsAutorenewals
      include Client::DomainsPrivacy
      include Client::DomainsSharing
      include Client::DomainsForwards
      include Client::DomainsZones
    end


    require 'dnsimple/client/name_servers'

    class NameServersService < ClientService
      include Client::NameServers
    end


    require 'dnsimple/client/vanity_name_servers'

    class VanityNameServersService < ClientService
      include Client::VanityNameServers
    end


    require 'dnsimple/client/registrar'

    class RegistrarService < ClientService
      include Client::Registrar
    end


    require 'dnsimple/client/services'
    require 'dnsimple/client/services_domains'

    class ServicesService < ClientService
      include Client::Services
      include Client::ServicesDomains
    end


    require 'dnsimple/client/templates'
    require 'dnsimple/client/templates_records'

    class TemplatesService < ClientService
      include Client::Templates
      include Client::TemplatesRecords
    end


    require 'dnsimple/client/users'

    class UsersService < ClientService
      include Client::Users
    end

  end
end
