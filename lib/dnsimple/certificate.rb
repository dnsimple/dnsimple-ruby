module DNSimple #:nodoc:
  class Certificate
    include HTTParty
    #debug_output $stdout

    # The certificate ID in DNSimple
    attr_accessor :id

    attr_accessor :domain

    # The subdomain on the certificate
    attr_accessor :name

    # When the certificate was purchased
    attr_accessor :created_at

    # When the certificate was last updated
    attr_accessor :updated_at

    #:nodoc:
    def initialize(attributes)
      attributes.each do |key, value|
        m = "#{key}=".to_sym
        self.send(m, value) if self.respond_to?(m)
      end
    end

    def fqdn
      [name, domain.name].delete_if { |p| p !~ DNSimple::BLANK_REGEX }.join(".")
    end

    def submit

    end

    # Purchase a certificate under the given domain with the given name. The 
    # name will be appended to the domain name, and thus should only be the 
    # subdomain part.
    #
    # Example: DNSimple::Certificate.purchase(domain, 'www', contact)
    def self.purchase(domain, name, contact, options={})
      certificate_hash = {
        :name => name,
        :contact_id => contact.id
      }

      options.merge!(DNSimple::Client.standard_options_with_credentials)
      options.merge!({:body => {:certificate => certificate_hash}})
      
      response = self.post("#{DNSimple::Client.base_uri}/domains/#{domain.name}/certificates", options) 

      pp response if DNSimple::Client.debug?

      case response.code
      when 201
        return DNSimple::Certificate.new({:domain => domain}.merge(response["certificate"]))
      when 401
        raise RuntimeError, "Authentication failed"
      when 406
        raise DNSimple::CertificateExists.new("#{name}.#{domain.name}", response["errors"])
      else
        raise DNSimple::Error.new("#{name}.#{domain.name}", response["errors"])
      end
    end

    def self.all(domain, options={})
      options.merge!(DNSimple::Client.standard_options_with_credentials)

      response = self.get("#{DNSimple::Client.base_uri}/domains/#{domain.name}/certificates", options) 

      pp response if DNSimple::Client.debug?

      case response.code
      when 200
        response.map { |r| DNSimple::Certificate.new({:domain => domain}.merge(r["certificate"])) }
      when 401
        raise RuntimeError, "Authentication failed"
      else
        raise DNSimple::Error.new("#{name}.#{domain.name} list certificates error", response["errors"])
      end
    end

  end
end
