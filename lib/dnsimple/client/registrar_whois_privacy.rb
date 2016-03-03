module Dnsimple
  class Client
    module RegistrarWhoisPrivacy

      def get_whois_privacy(account_id, domain_name, options = {})
        endpoint = Client.versioned("/%s/registrar/domains/%s/whois_privacy" % [account_id, domain_name])
        response = client.get(endpoint, options)

        Dnsimple::Response.new(response, Struct::WhoisPrivacy.new(response["data"]))
      end

    end
  end
end
