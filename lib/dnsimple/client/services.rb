module Dnsimple
  class Client
    module Services

      # Lists the supported services.
      #
      # @see http://developer.dnsimple.com/services/#list
      #
      # @return [Array<Struct::Service>]
      #
      # @raise  [RequestError] When the request fails.
      def services(options = {})
        response = client.get("v1/services", options)

        response.map { |r| Struct::Service.new(r["service"]) }
      end
      alias :list :services
      alias :list_services :services

      # Gets a service.
      #
      # @see http://developer.dnsimple.com/services/#get
      #
      # @param  [Fixnum] service The service id.
      # @return [Struct::Service]
      #
      # @raise  [NotFoundError]
      # @raise  [RequestError] When the request fails.
      def service(service, options = {})
        response = client.get("v1/services/#{service}", options)

        Struct::Service.new(response["service"])
      end

    end
  end
end
