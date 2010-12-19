module DNSimple #:nodoc:
  # Class representing a service that can be applied to a domain
  class Service
    include HTTParty

    attr_accessor :id

    attr_accessor :name

    attr_accessor :short_name

    attr_accessor :description

     #:nodoc:
    def initialize(attributes)
      attributes.each do |key, value|
        m = "#{key}=".to_sym
        self.send(m, value) if self.respond_to?(m)
      end
    end

    # Find a service by its ID or short name
    def self.find(id_or_short_name, options={})
      options.merge!({:basic_auth => Client.credentials})
      response = self.get("#{Client.base_uri}/services/#{id_or_short_name}.json", options)
      
      pp response if Client.debug?
      
      case response.code
      when 200
        return Service.new(response["service"])
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
      options.merge!({:basic_auth => Client.credentials})
      response = self.get("#{Client.base_uri}/services.json", options)
      
      pp response if Client.debug?

      case response.code
      when 200
        response.map { |r| Service.new(r["service"]) }
      when 401
        raise RuntimeError, "Authentication failed"
      else
        raise RuntimeError, "Error: #{response.code}"
      end
    end
  end
end
