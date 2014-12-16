module Dnsimple
  class Client
    class ServicesService < ClientService

      # Lists the supported services.
      #
      # @see http://developer.dnsimple.com/services/#list
      #
      # @return [Array<Service>]
      # @raise  [RequestError] When the request fails.
      def list
        response = client.get("v1/services")

        response.map { |r| Service.new(r["service"]) }
      end

      # Gets a service.
      #
      # @see http://developer.dnsimple.com/services/#get
      #
      # @param  [Fixnum] service The service id.
      #
      # @return [Service]
      # @raise  [RecordNotFound]
      # @raise  [RequestError] When the request fails.
      def find(service)
        response = client.get("v1/services/#{service}")

        Service.new(response["service"])
      end

      # Lists the services applied to a domain.
      #
      # @see http://developer.dnsimple.com/services/#applied
      #
      # @param  [#to_s] domain The domain id or domain name.
      #
      # @return [Array<Service>]
      # @raise  [RecordNotFound]
      # @raise  [RequestError] When the request fails.
      def applied(domain)
        response = client.get("v1/domains/#{domain}/applied_services")

        response.map { |r| Service.new(r["service"]) }
      end

      # Lists the services not applied to a domain.
      #
      # @see http://developer.dnsimple.com/services/#available
      #
      # @param  [#to_s] domain The domain id or domain name.
      #
      # @return [Array<Service>]
      # @raise  [RecordNotFound]
      # @raise  [RequestError] When the request fails.
      def available(domain)
        response = client.get("v1/domains/#{domain}/available_services")

        response.map { |r| Service.new(r["service"]) }
      end

      # Applies a service to a domain.
      #
      # @see http://developer.dnsimple.com/services/#apply
      #
      # @param  [#to_s] domain The domain id or domain name.
      # @param  [Fixnum] service The service id.
      #
      # @return [void]
      # @raise  [RecordNotFound]
      # @raise  [RequestError] When the request fails.
      def apply(domain, service)
        options  = { service: { id: service }}
        response = client.post("v1/domains/#{domain}/applied_services", options)
        response.code == 200
      end

      # Un-applies a service from a domain.
      #
      # @see http://developer.dnsimple.com/services/#unapply
      #
      # @param  [#to_s] domain The domain id or domain name.
      # @param  [Fixnum] service The service id.
      #
      # @return [void]
      # @raise  [RecordNotFound]
      # @raise  [RequestError] When the request fails.
      def unapply(domain, service)
        response = client.delete("v1/domains/#{domain}/applied_services/#{service}")
        response.code == 200
      end

    end
  end
end
