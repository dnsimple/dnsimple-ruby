module Dnsimple
  class Client

    # @return [Dnsimple::Client::ContactsService] The contact-related API proxy.
    def contacts
      @services[:domains] ||= Client::ContactsService.new(self)
    end

    # @return [Dnsimple::Client::DomainsService] The domain-related API proxy.
    def domains
      @services[:domains] ||= Client::DomainsService.new(self)
    end

    # @return [Dnsimple::Client::IdentityService] The identity-related API proxy.
    def identity
      @services[:auth] ||= Client::IdentityService.new(self)
    end

    # @return [Dnsimple::Client::OauthService] The oauth-related API proxy.
    def oauth
      @services[:oauth] ||= Client::OauthService.new(self)
    end

    # @return [Dnsimple::Client::RegistrarService] The registrar-related API proxy.
    def registrar
      @services[:registrar] ||= Client::RegistrarService.new(self)
    end

    # @return [Dnsimple::Client::TldsService] The tld-related API proxy.
    def tlds
      @services[:tlds] ||= Client::TldsService.new(self)
    end

    # @return [Dnsimple::Client::ZonesService] The zone-related API proxy.
    def zones
      @services[:zones] ||= Client::ZonesService.new(self)
    end

    # @return [Dnsimple::Client::WebhooksService] The webhooks-related API proxy.
    def webhooks
      @services[:webhooks] ||= Client::WebhooksService.new(self)
    end


    class ClientService < ::Struct.new(:client)

      # Internal helper that loops over a paginated response and returns all the records in the collection.
      #
      # @api private
      #
      # @param  [Symbol] method The client method to execute
      # @param  [Array] args The args to call the method with
      # @return [Dnsimple::CollectionResponse]
      def paginate(method, *args)
        current_page = 0
        total_pages = nil
        collection = []
        options = args.pop
        response = nil

        begin
          current_page += 1
          query = Extra.deep_merge(options, query: { page: current_page, per_page: 100 })

          response = send(method, *(args + [query]))
          total_pages ||= response.total_pages
          collection.concat(response.data)
        end while current_page < total_pages

        CollectionResponse.new(response.response, collection)
      end

    end


    require_relative 'contacts'

    class ContactsService < ClientService
      include Client::Contacts
    end


    require_relative 'domains'
    require_relative 'domains_email_forwards'

    class DomainsService < ClientService
      include Client::Domains
      include Client::DomainsEmailForwards
    end


    require_relative 'identity'

    class IdentityService < ClientService
      include Client::Identity
    end


    require_relative 'oauth'

    class OauthService < ClientService
      include Client::Oauth
    end


    require_relative 'registrar'
    require_relative 'registrar_auto_renewal'

    class RegistrarService < ClientService
      include Client::Registrar
      include Client::RegistrarAutoRenewal
    end


    require_relative 'tlds'

    class TldsService < ClientService
      include Client::Tlds
    end


    require_relative 'zones'
    require_relative 'zones_records'

    class ZonesService < ClientService
      include Client::Zones
      include Client::ZonesRecords
    end

    require_relative 'webhooks'

    class WebhooksService < ClientService
      include Client::Webhooks
    end

  end
end
