module DNSimple

  # Represents a service that can be applied to a domain.
  class Service < Base

    attr_accessor :id

    attr_accessor :name

    attr_accessor :short_name

    attr_accessor :description

    # Find a service by its ID or short name
    def self.find(id_or_short_name, options={})
      id = id_or_short_name
      response = DNSimple::Client.get("services/#{id}.json", options)

      case response.code
      when 200
        new(response["service"])
      when 404
        raise RecordNotFound, "Could not find service #{id}"
      else
        raise RequestError, "Error finding service", response
      end
    end

    # Get all of the services that can be applied to a domain
    def self.all(options={})
      response = DNSimple::Client.get 'services.json', options

      case response.code
      when 200
        response.map { |r| new(r["service"]) }
      else
        raise RequestError, "Error listing services", response
      end
    end

  end
end
