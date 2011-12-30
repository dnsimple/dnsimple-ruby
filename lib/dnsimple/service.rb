class DNSimple::Service < DNSimple::Base # Class representing a service that can be applied to a domain
  attr_accessor :id

  attr_accessor :name

  attr_accessor :short_name

  attr_accessor :description

  # Find a service by its ID or short name
  def self.find(id_or_short_name, options={})
    response = DNSimple::Client.get("services/#{id_or_short_name}.json", options)
    pp response if Client.debug?

    case response.code
    when 200
      return new(response["service"])
    when 401
      raise RuntimeError, "Authentication failed"
    when 404
      raise RuntimeError, "Could not find service #{id_or_short_name}"
    else
      raise DNSimple::Error.new(id_or_short_name, response["errors"])
    end
  end

  # Get all of the services that can be applied to a domain
  def self.all(options={})
    response = DNSimple::Client.get 'services.json', options
    pp response if Client.debug?

    case response.code
    when 200
      response.map { |r| new(r["service"]) }
    when 401
      raise RuntimeError, "Authentication failed"
    else
      raise RuntimeError, "Error: #{response.code}"
    end
  end
end
