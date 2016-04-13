module Dnsimple
  class Client
    module RegistrarDelegation

      def domain_delegation(account_id, domain_name, options = {})
        endpoint = Client.versioned("/%s/registrar/domains/%s/delegation" % [account_id, domain_name])
        response = client.get(endpoint, options)

        Dnsimple::Response.new(response, response["data"])
      end

    end
  end
end
