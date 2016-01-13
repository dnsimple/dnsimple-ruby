module Dnsimple
  class Client

    # @return [Dnsimple::Client::DomainsService] The domain-related API proxy.
    def domains
      @services[:domains] ||= Client::DomainsService.new(self)
    end

    # @return [Dnsimple::Client::AuthService] The authentication-methods API proxy.
    def auth
      @services[:auth] ||= Client::AuthService.new(self)
    end

    # @return [Dnsimple::Client::ZonesService] The zone-related API proxy.
    def zones
      @services[:zones] ||= Client::ZonesService.new(self)
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


    require_relative 'domains'

    class DomainsService < ClientService
      include Client::Domains
    end


    require_relative 'auth'

    class AuthService < ClientService
      include Client::Auth
    end


    require_relative 'zones_records'

    class ZonesService < ClientService
      include Client::ZonesRecords
    end

  end
end
