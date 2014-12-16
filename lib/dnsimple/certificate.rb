module Dnsimple

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

    # The Date the certificate was create in DNSimple.
    attr_accessor :created_at

    # The Date the certificate was last updated in DNSimple.
    attr_accessor :updated_at

    # The Date the certificate was configured.
    attr_accessor :configured_at

    # The Date the certificate will expire.
    attr_accessor :expires_on

    # The associated Domain.
    attr_accessor :domain

  end

end
