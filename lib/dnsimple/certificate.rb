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

    def self.purchase(domain_name, name, options={})
      domain = DNSimple::Domain.find(domain_name)

      certificate_hash = {
        :name => name
      }

      options.merge!(DNSimple::Client.standard_options_with_credentials)
      options.merge!({:body => {:certificate => certificate_hash}})
      
      response = self.post("#{DNSimple::Client.base_uri}/domains/#{domain.id}/certificates", options) 

      pp response if DNSimple::Client.debug?

      case response.code
      when 201
        return DNSimple::Certificate.new({:domain => domain}.merge(response["certificate"]))
      when 401
        raise RuntimeError, "Authentication failed"
      when 406
        raise DNSimple::CertificateExists.new("#{name}.#{domain_name}", response["errors"])
      else
        raise DNSimple::Error.new("#{name}.#{domain_name}", response["errors"])
      end
    end
  end
end
