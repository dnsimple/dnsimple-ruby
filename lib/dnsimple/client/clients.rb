# frozen_string_literal: true

module Dnsimple

  class Client

    # @return [Dnsimple::Client::AccountsService] The account-related API proxy.
    def accounts
      @services[:accounts] ||= Client::AccountsService.new(self)
    end

    # @return [Dnsimple::Client::BillingService] The billing-related API proxy.
    def billing
      @services[:billing] ||= Client::BillingService.new(self)
    end

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

    def dns_analytics
      @services[:dns_analytics] ||= Client::DnsAnalyticsService.new(self)
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

    # @return [Dnsimple::Client::ServicesService] The one-click-service-related API proxy.
    def services
      @services[:services] ||= Client::ServicesService.new(self)
    end

    # @return [Dnsimple::Client::TemplatesService] The templates-related API proxy.
    def templates
      @services[:templates] ||= Client::TemplatesService.new(self)
    end

    # @return [Dnsimple::Client::TldsService] The tld-related API proxy.
    def tlds
      @services[:tlds] ||= Client::TldsService.new(self)
    end

    # @return [Dnsimple::Client::VanityNameServersService] The vanity-name-server-related API proxy.
    def vanity_name_servers
      @services[:vanity_name_servers] ||= Client::VanityNameServersService.new(self)
    end

    # @return [Dnsimple::Client::ZonesService] The zone-related API proxy.
    def zones
      @services[:zones] ||= Client::ZonesService.new(self)
    end

    # @return [Dnsimple::Client::WebhooksService] The webhooks-related API proxy.
    def webhooks
      @services[:webhooks] ||= Client::WebhooksService.new(self)
    end


    # Struct
    class ClientService

      # @return [Dnsimple::Client]
      attr_reader :client

      def initialize(client)
        @client = client
      end

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

        loop do
          current_page += 1
          query = Extra.deep_merge(options, query: { page: current_page, per_page: 100 })

          response = send(method, *(args + [query]))
          total_pages ||= response.total_pages
          collection.concat(response.data)
          break unless current_page < total_pages
        end

        CollectionResponse.new(response.http_response, collection)
      end

    end


    require_relative 'accounts'

    class AccountsService < ClientService

      include Client::Accounts

    end

    require_relative 'billing'

    class BillingService < ClientService

      include Client::Billing

    end

    require_relative 'certificates'

    class CertificatesService < ClientService

      include Client::Certificates

    end


    require_relative 'contacts'

    class ContactsService < ClientService

      include Client::Contacts

    end


    require_relative 'domains'
    require_relative 'domains_delegation_signer_records'
    require_relative 'domains_dnssec'
    require_relative 'domains_email_forwards'
    require_relative 'domains_pushes'
    require_relative 'domains_collaborators'

    class DomainsService < ClientService

      include Client::Domains
      include Client::DomainsDelegationSignerRecords
      include Client::DomainsDnssec
      include Client::DomainsEmailForwards
      include Client::DomainsPushes
      include Client::DomainsCollaborators

    end

    require_relative 'dns_analytics'

    class DnsAnalyticsService < ClientService
      include Client::DnsAnalytics
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
    require_relative 'registrar_whois_privacy'
    require_relative 'registrar_registrant_changes'
    require_relative 'registrar_transfer_lock'
    require_relative 'registrar_delegation'

    class RegistrarService < ClientService

      include Client::Registrar
      include Client::RegistrarAutoRenewal
      include Client::RegistrarDelegation
      include Client::RegistrarRegistrantChanges
      include Client::RegistrarTransferLock
      include Client::RegistrarWhoisPrivacy

    end


    require_relative 'services'
    require_relative 'services_domains'

    class ServicesService < ClientService

      include Client::Services
      include Client::ServicesDomains

    end


    require_relative 'templates'
    require_relative 'templates_domains'
    require_relative 'templates_records'

    class TemplatesService < ClientService

      include Client::Templates
      include Client::TemplatesDomains
      include Client::TemplatesRecords

    end


    require_relative 'tlds'

    class TldsService < ClientService

      include Client::Tlds

    end


    require_relative 'vanity_name_servers'

    class VanityNameServersService < ClientService

      include Client::VanityNameServers

    end


    require_relative 'zones'
    require_relative 'zones_records'
    require_relative 'zones_distributions'

    class ZonesService < ClientService

      include Client::Zones
      include Client::ZonesRecords
      include Client::ZonesDistributions

    end


    require_relative 'webhooks'

    class WebhooksService < ClientService

      include Client::Webhooks

    end

  end

  # This module exposes static helpers for the API v2.
  #
  # Compared to the full, extended API methods provided by the various client services,
  # these static methods return directly the underlying data objects.
  # Therefore, it's not possible to access response metadata such as throttling or pagination info.
  module V2

    extend Client::Identity::StaticHelpers

  end

end
