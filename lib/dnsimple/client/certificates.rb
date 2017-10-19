module Dnsimple
  class Client
    module Certificates

      # Lists the certificates associated to the domain.
      #
      # @see https://developer.dnsimple.com/v2/domains/certificates/#list
      # @see #all_certificates
      #
      # @example List certificates in the first page
      #   client.certificates.list(1010, "example.com")
      #
      # @example List certificates, provide a specific page
      #   client.certificates.list(1010, "example.com", page: 2)
      #
      # @example List certificates, provide a sorting policy
      #   client.certificates.list(1010, "example.com", sort: "email:asc")
      #
      # @param  account_id  [Integer] the account ID
      # @param  domain_name [#to_s] The domain ID or domain name
      # @param  options [Hash] the filtering and sorting options
      # @option options [Integer] :page current page (pagination)
      # @option options [Integer] :per_page number of entries to return (pagination)
      # @return [Dnsimple::PaginatedResponse<Dnsimple::Struct::Certificate>]
      #
      # @raise  [Dnsimple::RequestError]
      def certificates(account_id, domain_name, options = {})
        response = client.get(Client.versioned("/%s/domains/%s/certificates" % [account_id, domain_name]), Options::ListOptions.new(options))

        Dnsimple::PaginatedResponse.new(response, response["data"].map { |r| Struct::Certificate.new(r) })
      end

      # Lists ALL the certificates for the domain.
      #
      # This method is similar to {#certificates}, but instead of returning the results of a specific page
      # it iterates all the pages and returns the entire collection.
      #
      # Please use this method carefully, as fetching the entire collection will increase the number of requests
      # you send to the API server and you may eventually risk to hit the throttle limit.
      #
      # @see https://developer.dnsimple.com/v2/domains/certificates/#list
      # @see #certificates
      #
      # @param  account_id [Integer] the account ID
      # @param  domain_name [#to_s] The domain ID or domain name
      # @param  options [Hash] the filtering and sorting option
      # @option options [Integer] :page current page (pagination)
      # @option options [Integer] :per_page number of entries to return (pagination)
      # @option options [String] :sort sorting policy
      # @return [Dnsimple::CollectionResponse<Dnsimple::Struct::Certificate>]
      #
      # @raise  [Dnsimple::RequestError]
      def all_certificates(account_id, domain_name, options = {})
        paginate(:certificates, account_id, domain_name, options)
      end

      # Gets a certificate associated to the domain.
      #
      # @see https://developer.dnsimple.com/v2/domains/certificates/#get
      #
      # @param  account_id [Integer] the account ID
      # @param  domain_id [#to_s] the domain ID or domain name
      # @param  certificate_id [Integer] the certificate ID
      # @param  options [Hash]
      # @return [Dnsimple::Response<Dnsimple::Struct::Certificate>]
      #
      # @raise  [Dnsimple::NotFoundError]
      # @raise  [Dnsimple::RequestError]
      def certificate(account_id, domain_id, certificate_id, options = {})
        response = client.get(Client.versioned("/%s/domains/%s/certificates/%s" % [account_id, domain_id, certificate_id]), options)

        Dnsimple::Response.new(response, Struct::Certificate.new(response["data"]))
      end

      # Downloads a certificate associated to the domain.
      #
      # @see https://developer.dnsimple.com/v2/domains/certificates/#download
      #
      # @param  account_id [Integer] the account ID
      # @param  domain_id [#to_s] the domain ID or domain name
      # @param  certificate_id [Integer] the certificate ID
      # @param  options [Hash]
      # @return [Dnsimple::Response<Dnsimple::Struct::CertificateBundle>]
      #
      # @raise  [Dnsimple::NotFoundError]
      # @raise  [Dnsimple::RequestError]
      def download_certificate(account_id, domain_id, certificate_id, options = {})
        response = client.get(Client.versioned("/%s/domains/%s/certificates/%s/download" % [account_id, domain_id, certificate_id]), options)

        Dnsimple::Response.new(response, Struct::CertificateBundle.new(response["data"]))
      end

      # Get certificate private key associated to the domain.
      #
      # @see https://developer.dnsimple.com/v2/domains/certificates/#get-private-key
      #
      # @param  account_id [Integer] the account ID
      # @param  domain_id [#to_s] the domain ID or domain name
      # @param  certificate_id [Integer] the certificate ID
      # @param  options [Hash]
      # @return [Dnsimple::Response<Dnsimple::Struct::CertificateBundle>]
      #
      # @raise  [Dnsimple::NotFoundError]
      # @raise  [Dnsimple::RequestError]
      def certificate_private_key(account_id, domain_id, certificate_id, options = {})
        response = client.get(Client.versioned("/%s/domains/%s/certificates/%s/private_key" % [account_id, domain_id, certificate_id]), options)

        Dnsimple::Response.new(response, Struct::CertificateBundle.new(response["data"]))
      end

      # Purchase a Let's Encrypt certificate.
      #
      # This method creates a new certificate order. The certificate ID should be used to
      # request the issuance of the certificate using {#letsencrypt_issue}.
      #
      # @see https://developer.dnsimple.com/v2/domains/certificates/#letsencrypt-purchase
      #
      # @param  account_id [Integer] the account ID
      # @param  domain_id [#to_s] the domain ID or domain name
      # @param  attributes [Hash]
      # @option attributes [Integer] :contact_id the contact ID (mandatory)
      # @option attributes [String] :name the certificate name (optional)
      # @option attributes [Array<String>] :alternate_names the certificate alternate names (optional)
      # @option attributes [TrueClass,FalseClass] :auto_renew enable certificate auto renew (optional)
      # @param  options[Hash]
      #
      # @return [Dnsimple::Response<Dnsimple::Struct::Certificate>]
      #
      # @raise  [Dnsimple::NotFoundError]
      # @raise  [Dnsimple::RequestError]
      #
      # @example Basic usage
      #   reponse     = client.certificates.letsencrypt_purchase(1010, "example.com", contact_id: 1)
      #   certificate = response.data
      #
      #   certificate.id              # => 100
      #   certificate.name            # => "www"
      #   certificate.common_name     # => "www.example.com"
      #   certificate.alternate_names # => []
      #   certificate.auto_renew      # => false
      #
      # @example Custom name
      #   reponse     = client.certificates.letsencrypt_purchase(1010, "example.com", contact_id: 1, name: "docs")
      #   certificate = response.data
      #
      #   certificate.id              # => 100
      #   certificate.name            # => "docs"
      #   certificate.common_name     # => "docs.example.com"
      #   certificate.alternate_names # => []
      #   certificate.auto_renew      # => false
      #
      # @example SAN names
      #   reponse     = client.certificates.letsencrypt_purchase(1010, "example.com", contact_id: 1, alternate_names: ["api.example.com", "status.example.com"])
      #   certificate = response.data
      #
      #   certificate.id              # => 100
      #   certificate.name            # => "www"
      #   certificate.common_name     # => "www.example.com"
      #   certificate.alternate_names # => ["api.example.com", "status.example.com"]
      #   certificate.auto_renew      # => false
      #
      # @example Auto renew
      #   reponse     = client.certificates.letsencrypt_purchase(1010, "example.com", contact_id: 1, auto_renew: true)
      #   certificate = response.data
      #
      #   certificate.id              # => 100
      #   certificate.name            # => "www"
      #   certificate.common_name     # => "www.example.com"
      #   certificate.alternate_names # => []
      #   certificate.auto_renew      # => true
      def letsencrypt_purchase(account_id, domain_id, attributes, options = {})
        Extra.validate_mandatory_attributes(attributes, [:contact_id])
        response = client.post(Client.versioned("/%s/domains/%s/certificates/letsencrypt" % [account_id, domain_id]), attributes, options)

        Dnsimple::Response.new(response, Struct::Certificate.new(response["data"]))
      end

      # Issue a pending Let's Encrypt certificate order.
      #
      # Note that the issuance process is async. A successful response means the issuance
      # request has been successfully acknowledged and queued for processing.
      #
      # @see https://developer.dnsimple.com/v2/domains/certificates/#letsencrypt-issue
      #
      # @param  account_id [Integer] the account ID
      # @param  domain_id [#to_s] the domain ID or domain name
      # @param  certificate_id [Integer] the certificate ID returned by the purchase method
      # @param  options [Hash]
      #
      # @return [Dnsimple::Response<Dnsimple::Struct::Certificate>]
      #
      # @raise  [Dnsimple::NotFoundError]
      # @raise  [Dnsimple::RequestError]
      #
      # @example Basic usage
      #   reponse     = client.certificates.letsencrypt_issue(1010, "example.com", 100)
      #   certificate = response.data
      #
      #   certificate.state # => "requesting"
      def letsencrypt_issue(account_id, domain_id, certificate_id, options = {})
        response = client.post(Client.versioned("/%s/domains/%s/certificates/letsencrypt/%s/issue" % [account_id, domain_id, certificate_id]), options)

        Dnsimple::Response.new(response, Struct::Certificate.new(response["data"]))
      end

      # Purchase a Let's Encrypt certificate renewal.
      #
      # @see https://developer.dnsimple.com/v2/domains/certificates/#letsencrypt-purchase-renewal
      #
      # @param  account_id [Integer] the account ID
      # @param  domain_id [#to_s] the domain ID or domain name
      # @param  certificate_id [Integer] the certificate ID
      # @param  attributes [Hash]
      # @option attributes [TrueClass,FalseClass] :auto_renew enable certificate auto renew (optional)
      # @param  options [Hash]
      #
      # @return [Dnsimple::Response<Dnsimple::Struct::CertificateRenewal>]
      #
      # @raise  [Dnsimple::NotFoundError]
      # @raise  [Dnsimple::RequestError]
      #
      # @example Basic usage
      #   reponse             = client.certificates.letsencrypt_purchase(1010, "example.com", 200)
      #   certificate_renewal = response.data
      #
      #   certificate_renewal.id                 # => 999
      #   certificate_renewal.old_certificate_id # => 200
      #   certificate_renewal.new_certificate_id # => 200
      #
      # @example Auto renew
      #   reponse             = client.certificates.letsencrypt_purchase(1010, "example.com", 200, auto_renew: true)
      #   certificate_renewal = response.data
      #
      #   certificate_renewal.id                 # => 999
      #   certificate_renewal.old_certificate_id # => 200
      #   certificate_renewal.new_certificate_id # => 200
      def letsencrypt_purchase_renewal(account_id, domain_id, certificate_id, attributes = {}, options = {})
        response = client.post(Client.versioned("/%s/domains/%s/certificates/letsencrypt/%s/renewals" % [account_id, domain_id, certificate_id]), attributes, options)

        Dnsimple::Response.new(response, Struct::CertificateRenewal.new(response["data"]))
      end

      # Issue a pending Let's Encrypt certificate renewal order.
      #
      # Note that the issuance process is async. A successful response means the issuance
      # request has been successfully acknowledged and queued for processing.
      #
      # @see https://developer.dnsimple.com/v2/domains/certificates/#letsencrypt-issue-renewal
      #
      # @param  account_id [Integer] the account ID
      # @param  domain_id [#to_s] the domain ID or domain name
      # @param  certificate_id [Integer] the certificate ID
      # @param  certificate_renewal_id [Integer] the certificate renewal ID
      # @param  options [Hash]
      #
      # @return [Dnsimple::Response<Dnsimple::Struct::Certificate>]
      #
      # @raise  [Dnsimple::NotFoundError]
      # @raise  [Dnsimple::RequestError]
      #
      # @example Basic usage
      #   reponse     = client.certificates.letsencrypt_issue_renewal(1010, "example.com", 100, 999)
      #   certificate = response.data
      #
      #   certificate.state # => "requesting"
      def letsencrypt_issue_renewal(account_id, domain_id, certificate_id, certificate_renewal_id, options = {})
        response = client.post(Client.versioned("/%s/domains/%s/certificates/letsencrypt/%s/renewals/%s/issue" % [account_id, domain_id, certificate_id, certificate_renewal_id]), options)

        Dnsimple::Response.new(response, Struct::Certificate.new(response["data"]))
      end

    end
  end
end
