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
