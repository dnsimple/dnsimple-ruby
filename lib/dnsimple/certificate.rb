# Represents an SSL certificate that has been purchased. The certificate
# must also be submitted using the #submit method before the Certificate
# Authority will issue a signed certificate.
class DNSimple::Certificate < DNSimple::Base
  #debug_output $stdout

  # The certificate ID in DNSimple
  attr_accessor :id

  attr_accessor :domain

  # The subdomain on the certificate
  attr_accessor :name

  # The private key, if DNSimple generated the Certificate Signing Request
  attr_accessor :private_key

  # The SSL certificate, if it has been issued by the Certificate Authority
  attr_accessor :ssl_certificate

  # The Certificate Signing Request
  attr_accessor :csr

  # The Certificate status
  attr_accessor :certificate_status

  # The date the Certificate order was placed
  attr_accessor :order_date

  # The date the Certificate will expire
  attr_accessor :expiration_date

  # The approver email address
  attr_accessor :approver_email

  # An array of all emails that can be used to approve the certificate
  attr_accessor :available_approver_emails

  # When the certificate was purchased
  attr_accessor :created_at

  # When the certificate was last updated
  attr_accessor :updated_at

  # Get the fully-qualified domain name for the certificate. This is the
  # domain.name joined with the certificate name, separated by a period.
  def fqdn
    [name, domain.name].delete_if { |p| p !~ DNSimple::BLANK_REGEX }.join(".")
  end

  def submit(approver_email, options={})
    raise DNSimple::Error, "Approver email is required" unless approver_email

    options.merge!(:body => {:certificate => {:approver_email => approver_email}})

    response = DNSimple::Client.put "domains/#{domain.name}/certificates/#{id}/submit", options

    case response.code
    when 200
      return DNSimple::Certificate.new({:domain => domain}.merge(response["certificate"]))
    else
      raise DNSimple::Error.new("Error submitting certificate: #{response["errors"]}")
    end
  end

  # Purchase a certificate under the given domain with the given name. The
  # name will be appended to the domain name, and thus should only be the
  # subdomain part.
  #
  # Example: DNSimple::Certificate.purchase(domain, 'www', contact)
  #
  # Please note that by invoking this method DNSimple will immediately charge
  # your credit card on file at DNSimple for the full certificate price.
  #
  # For wildcard certificates an asterisk must appear in the name.
  #
  # Example: DNSimple::Certificate.purchase(domain, '*', contact)
  def self.purchase(domain, name, contact, options={})
    certificate_hash = {
      :name => name,
      :contact_id => contact.id
    }

    options.merge!({:body => {:certificate => certificate_hash}})

    response = DNSimple::Client.post "domains/#{domain.name}/certificates", options

    case response.code
    when 201
      return new({:domain => domain}.merge(response["certificate"]))
    when 406
      raise DNSimple::CertificateExists.new("#{name}.#{domain.name}", response["errors"])
    else
      raise DNSimple::Error.new("#{name}.#{domain.name}", response["errors"])
    end
  end

  # Get an array of all certificates for the given domain.
  def self.all(domain, options={})
    response = DNSimple::Client.get "domains/#{domain.name}/certificates", options

    case response.code
    when 200
      response.map { |r| new({:domain => domain}.merge(r["certificate"])) }
    else
      raise DNSimple::Error.new("List certificates error: #{response["errors"]}")
    end
  end

  # Find a specific certificate for the given domain.
  def self.find(domain, certificate_id, options={})
    response = DNSimple::Client.get "domains/#{domain.name}/certificates/#{certificate_id}", options

    case response.code
    when 200
      new({:domain => domain}.merge(response["certificate"]))
    when 404
      raise DNSimple::CertificateNotFound, "Could not find certificate #{certificate_id} for domain #{domain.name}"
    else
      raise DNSimple::Error.new("Find certificate error: #{response["errors"]}")
    end
  end
end
