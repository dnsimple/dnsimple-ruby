module Dnsimple

  # Represents an SSL certificate that has been purchased.
  #
  # The certificate must also be submitted using the #submit method
  # before the Certificate Authority will issue a signed certificate.
  class Certificate < Base

    # The Fixnum certificate ID in DNSimple.
    attr_accessor :id

    # The Fixnum associated domain ID.
    attr_accessor :domain_id

    # The Fixnum associated contact ID.
    attr_accessor :contact_id

    # The String subdomain on the certificate.
    attr_accessor :name

    # The String state.
    attr_accessor :state

    # The String Certificate Signing Request.
    attr_accessor :csr

    # The String SSL certificate.
    # It is set only if the order issued by the Certificate Authority.
    attr_accessor :ssl_certificate

    # The String private key.
    # It is set only if DNSimple generated the Certificate Signing Request.
    attr_accessor :private_key

    # The String approver email address
    # It is set only if the state is submitted.
    attr_accessor :approver_email

    # The Array of all emails that can be used to approve the certificate.
    # It is set only if the state is configured.
    attr_accessor :approver_emails

    # The Date the certificate was purchased
    attr_accessor :created_at

    # The Date the certificate was last updated
    attr_accessor :updated_at

    # The Date the certificate was configured
    attr_accessor :configured_at

    # The Date the Certificate will expire
    attr_accessor :expires_on

    # The associated Domain.
    attr_accessor :domain


    # Purchases a certificate under the given domain with the given name.
    #
    # The name will be appended to the domain name, and thus should only be the subdomain part.
    #
    # Invoking this method DNSimple will immediately charge
    # your credit card on file at DNSimple for the full certificate price.
    #
    # For wildcard certificates an asterisk must appear in the name.
    #
    # @example Purchase a single-hostname certificate
    #   Dnsimple::Certificate.purchase(domain, 'www', contact)
    #
    # @example Purchase a wildcard certificate
    #   Dnsimple::Certificate.purchase(domain, '*', contact)
    #
    def self.purchase(domain, name, contact, options={})
      certificate_hash = {
        :name => name,
        :contact_id => contact.id
      }

      options.merge!({:body => {:certificate => certificate_hash}})

      response = Client.post("/v1/domains/#{domain.name}/certificates", options)

      case response.code
      when 201
        new({ :domain => domain }.merge(response["certificate"]))
      when 406
        raise RecordExists, "Certificate for #{domain.name} already exists"
      else
        raise RequestError.new("Error purchasing certificate", response)
      end
    end

    # Get an array of all certificates for the given domain.
    def self.all(domain, options={})
      response = Client.get("/v1/domains/#{domain.name}/certificates", options)

      case response.code
      when 200
        response.map { |r| new({:domain => domain}.merge(r["certificate"])) }
      else
        raise RequestError.new("Error listing certificates", response)
      end
    end

    # Find a specific certificate for the given domain.
    def self.find(domain, id, options = {})
      response = Client.get("/v1/domains/#{domain.name}/certificates/#{id}", options)

      case response.code
      when 200
        new({:domain => domain}.merge(response["certificate"]))
      when 404
        raise RecordNotFound, "Could not find certificate #{id} for domain #{domain.name}"
      else
        raise RequestError.new("Error finding certificate", response)
      end
    end


    # Get the fully-qualified domain name for the certificate. This is the
    # domain.name joined with the certificate name, separated by a period.
    def fqdn
      [name, domain.name].delete_if { |p| p !~ BLANK_REGEX }.join(".")
    end

    def submit(approver_email, options={})
      raise Error, "Approver email is required" unless approver_email

      options.merge!(:body => {:certificate => {:approver_email => approver_email}})

      response = Client.put("/v1/domains/#{domain.name}/certificates/#{id}/submit", options)

      case response.code
      when 200
        Certificate.new({ :domain => domain }.merge(response["certificate"]))
      else
        raise RequestError.new("Error submitting certificate", response)
      end
    end

  end
end
