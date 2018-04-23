module Dnsimple
  class Client
    module Registrar

      # Checks whether a domain is available to be registered.
      #
      # @see https://developer.dnsimple.com/v2/registrar/#check
      #
      # @example Check whether example.com is available:
      #   client.registrar.check_domain(1010, "example.com")
      #
      # @param  [Integer] account_id the account ID
      # @param  [#to_s] domain_name the domain name to check
      # @param  [Hash] options
      # @return [Struct::DomainCheck]
      #
      # @raise  [RequestError] When the request fails.
      def check_domain(account_id, domain_name, options = {})
        endpoint = Client.versioned("/%s/registrar/domains/%s/check" % [account_id, domain_name])
        response = client.get(endpoint, options)

        Dnsimple::Response.new(response, Struct::DomainCheck.new(response["data"]))
      end

      # Checks the premium price for a domain
      #
      # @see https://developer.dnsimple.com/v2/registrar/#premium-price
      #
      # @example Check the ruby.codes premium price:
      #   client.registrar.domain_premium_price(1010, "ruby.codes")
      #
      # @example Check the ruby.codes premium price for transfer:
      #   client.registrar.domain_premium_price(1010, "ruby.codes", action: "transfer")
      #
      # @param  [Integer] account_id the account ID
      # @param  [#to_s] domain_name the domain name to check
      # @param  [Hash] options
      # @option options [String] :action Optional action between "registration",
      #   "renewal", and "transfer". If omitted, it defaults to "registration".
      # @return [Struct::DomainPremiumPrice]
      #
      # @raise  [RequestError] When the request fails.
      def domain_premium_price(account_id, domain_name, options = {})
        endpoint = Client.versioned("/%s/registrar/domains/%s/premium_price" % [account_id, domain_name])
        options[:query] = { action: options.delete(:action) } if options.key?(:action)
        response = client.get(endpoint, options)

        Dnsimple::Response.new(response, Struct::DomainPremiumPrice.new(response["data"]))
      end

      # Registers a domain.
      #
      # @see https://developer.dnsimple.com/v2/registrar/#register
      #
      # @example Initiate the registration of example.com using the contact 1234 as registrant
      #   including WHOIS privacy for the domain and enabling auto renewal:
      #   client.registrar.register_domain(1010, "example.com", registrant_id: 1234, private_whois: true, auto_renew: true)
      #
      # @param  [Integer] account_id the account ID
      # @param  [#to_s] domain_name the domain name to register
      # @param  [Hash] attributes
      # @param  [Hash] options
      # @return [Struct::DomainRegistration]
      #
      # @raise  [RequestError] When the request fails.
      def register_domain(account_id, domain_name, attributes, options = {})
        Extra.validate_mandatory_attributes(attributes, [:registrant_id])
        endpoint = Client.versioned("/%s/registrar/domains/%s/registrations" % [account_id, domain_name])
        response = client.post(endpoint, attributes, options)

        Dnsimple::Response.new(response, Struct::DomainRegistration.new(response["data"]))
      end

      # Renews a domain.
      #
      # @see https://developer.dnsimple.com/v2/registrar/#renew
      #
      # @example Renew example.com for 3 years:
      #   client.registrar.renew_domain(1010, "example.com", period: 3)
      #
      # @param  [Integer] account_id the account ID
      # @param  [#to_s] domain_name the domain name to renew
      # @param  [Hash] attributes
      # @param  [Hash] options
      # @return [Struct::DomainRenewal]
      #
      # @raise  [RequestError] When the request fails.
      def renew_domain(account_id, domain_name, attributes = nil, options = {})
        endpoint = Client.versioned("/%s/registrar/domains/%s/renewals" % [account_id, domain_name])
        response = client.post(endpoint, attributes, options)

        Dnsimple::Response.new(response, Struct::DomainRenewal.new(response["data"]))
      end

      # Starts the transfer of a domain to DNSimple.
      #
      # @see https://developer.dnsimple.com/v2/registrar/#transfer
      #
      # @example Initiate the transfer for example.com using the contact 1234 as registrant:
      #   client.registrar.transfer_domain(1010, "example.com", registrant_id: 1234, auth_code: "x1y2z3")
      #
      # @param  [Integer] account_id the account ID
      # @param  [#to_s] domain_name the domain name to transfer
      # @param  [Hash] attributes
      # @param  [Hash] options
      # @return [Struct::DomainTransfer]
      #
      # @raise  [RequestError] When the request fails.
      def transfer_domain(account_id, domain_name, attributes, options = {})
        Extra.validate_mandatory_attributes(attributes, [:registrant_id])
        endpoint = Client.versioned("/%s/registrar/domains/%s/transfers" % [account_id, domain_name])
        response = client.post(endpoint, attributes, options)

        Dnsimple::Response.new(response, Struct::DomainTransfer.new(response["data"]))
      end

      # Requests the transfer of a domain out of DNSimple.
      #
      # @see https://developer.dnsimple.com/v2/registrar/#transfer-out
      #
      # @example Request to transfer of example.com out of DNSimple:
      #   client.registrar.transfer_domain_out(1010, "example.com")
      #
      # @param  [Integer] account_id the account ID
      # @param  [#to_s] domain_name the domain name to transfer out
      # @param  [Hash] options
      # @return [Dnsimple::Response<nil>]
      #
      # @raise  [RequestError] When the request fails.
      def transfer_domain_out(account_id, domain_name, options = {})
        endpoint = Client.versioned("/%s/registrar/domains/%s/authorize_transfer_out" % [account_id, domain_name])
        response = client.post(endpoint, nil, options)

        Dnsimple::Response.new(response, nil)
      end
    end
  end
end
