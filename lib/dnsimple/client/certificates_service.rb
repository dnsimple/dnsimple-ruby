module Dnsimple
  class Client
    class CertificatesService < ClientService

      # Lists the certificates for a domain.
      #
      # @see http://developer.dnsimple.com/domains/certificates/#list
      #
      # @param  [#to_s] domain The domain id or domain name.
      # @param  [Hash] options
      #
      # @return [Array<Certificate>]
      # @raise  [RecordNotFound]
      # @raise  [RequestError] When the request fails.
      def list(domain, options = {})
        response = client.get("v1/domains/#{domain}/certificates", options)

        response.map { |r| Certificate.new(r["certificate"]) }
      end

      # Gets a certificate for a domain.
      #
      # @see http://developer.dnsimple.com/domains/certificates/#get
      #
      # @param  [#to_s] domain The domain id or domain name.
      # @param  [Fixnum] certificate_id The certificate ID.
      #
      # @return [Certificate]
      # @raise  [RecordNotFound]
      # @raise  [RequestError] When the request fails.
      def find(domain, certificate_id)
        response = client.get("v1/domains/#{domain}/certificates/#{certificate_id}")

        Certificate.new(response["certificate"])
      end

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
      # @param  [#to_s] domain The domain id or domain name.
      # @param  [String] name The certificate name.
      # @param  [Fixnum] contact_id The ID of the contact associated to the certificate.
      #
      # @return [Certificate]
      # @raise  [RecordNotFound]
      # @raise  [RequestError] When the request fails.
      def purchase(domain, name, contact_id)
        options = { body: { certificate: { name: name, contact_id: contact_id }} }
        response = client.post("v1/domains/#{domain}/certificates", options)

        Certificate.new(response["certificate"])
      end

      # Configures a certificate.
      #
      # @param  [#to_s] domain The domain id or domain name.
      # @param  [Fixnum] certificate_id The certificate ID.
      #
      # @return [Certificate]
      # @raise  [RecordNotFound]
      # @raise  [RequestError] When the request fails.
      def configure(domain, certificate_id)
        response = client.put("v1/domains/#{domain}/certificates/#{certificate_id}/configure")

        Certificate.new(response["certificate"])
      end

      # Submits a certificate for approval.
      #
      # @param  [#to_s] domain The domain id or domain name.
      # @param  [Fixnum] certificate_id The certificate ID.
      # @param  [Fixnum] email The approver email.
      #
      # @return [Certificate]
      # @raise  [RecordNotFound]
      # @raise  [RequestError] When the request fails.
      def submit(domain, certificate_id, email)
        options = { body: { certificate: { approver_email: email }} }
        response = client.put("v1/domains/#{domain}/certificates/#{certificate_id}/submit", options)

        Certificate.new(response["certificate"])
      end

    end
  end
end
