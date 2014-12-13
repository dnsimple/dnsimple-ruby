module Dnsimple

  # Represents a service that can be applied to a domain.
  class Service < Base

    attr_accessor :id

    attr_accessor :name

    attr_accessor :short_name

    attr_accessor :description

    # Find a service by its ID or short name
    def self.find(id_or_short_name, options={})
      id = id_or_short_name
      response = Client.get("/v1/services/#{id}", options)

      case response.code
      when 200
        new(response["service"])
      when 404
        raise RecordNotFound, "Could not find service #{id}"
      else
        raise RequestError.new("Error finding service", response)
      end
    end

    # Get all of the services that can be applied to a domain
    def self.all(options={})
      response = Client.get("/v1/services", options)

      case response.code
      when 200
        response.map { |r| new(r["service"]) }
      else
        raise RequestError.new("Error listing services", response)
      end
    end

  end
end
