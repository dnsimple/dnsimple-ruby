module DNSimple
  class Template
    include HTTParty
    base_uri 'http://localhost:3000/'

    # The template ID in DNSimple
    attr_accessor :id
    
    # The template name
    attr_accessor :name

    # The template short name
    attr_accessor :short_name

    # The template description
    attr_accessor :description

    #:nodoc:
    def initialize(attributes)
      attributes.each do |key, value|
        m = "#{key}=".to_sym
        self.send(m, value) if self.respond_to?(m)
      end
    end

    def self.find(id_or_short_name, options={})
      options.merge!({:basic_auth => Client.credentials})
      response = self.get("/templates/#{id_or_short_name}.json", options)
      
      pp response if Client.debug?
      
      case response.code
      when 200
        return Template.new(response["dns_template"])
      when 401
        raise RuntimeError, "Authentication failed"
      when 404
        raise RuntimeError, "Could not find template #{id_or_short_name}"
      else
        raise DNSimple::Error.new(id_or_short_name, response["errors"])
      end
    end
  end
end
