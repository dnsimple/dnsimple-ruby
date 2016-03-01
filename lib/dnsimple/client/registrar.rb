module Dnsimple
  class Client
    module Registrar

      # Registers a domain.
      #
      # @see https://developer.dnsimple.com/v2/registrar/#register
      #
      # @param  [Fixnum] account_id the account ID
      # @param  [#to_s] domain_name The domain name to register.
      # @param  [Hash] attributes
      # @param  [Hash] options
      # @return [Struct::Domain]
      #
      # @raise  [RequestError] When the request fails.
      def register(account_id, domain_name, attributes = {}, options = {})
        Extra.validate_mandatory_attributes(attributes, [:registrant_id])
        options  = options.merge(attributes)
        response = client.post(Client.versioned("/%s/registrar/domains/%s/registration" % [account_id, domain_name]), options)

        Dnsimple::Response.new(response, Struct::Domain.new(response["data"]))
      end


      def check(account_id, domain_name, options = {})
        response = client.get(Client.versioned("/%s/registrar/domains/%s/check" % [account_id, domain_name]), options)

        Dnsimple::Response.new(response, Struct::DomainCheck.new(response["data"]))
      end

    end
  end
end
