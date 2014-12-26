require 'dnsimple/client/services_domains_service'

module Dnsimple
  class Client
    class ServicesService < ClientService

      # Lists the supported services.
      #
      # @see http://developer.dnsimple.com/services/#list
      #
      # @return [Array<Struct::Service>]
      # @raise  [RequestError] When the request fails.
      def list
        response = client.get("v1/services")

        response.map { |r| Struct::Service.new(r["service"]) }
      end

      # Gets a service.
      #
      # @see http://developer.dnsimple.com/services/#get
      #
      # @param  [Fixnum] service The service id.
      #
      # @return [Struct::Service]
      # @raise  [RecordNotFound]
      # @raise  [RequestError] When the request fails.
      def find(service)
        response = client.get("v1/services/#{service}")

        Struct::Service.new(response["service"])
      end

    end
  end
end
