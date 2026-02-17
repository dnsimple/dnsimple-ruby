# frozen_string_literal: true

module Dnsimple
  class Client
    module DomainsResearch
      # Research a domain name for availability and registration status information.
      #
      # This endpoint provides information about a domain's availability status.
      #
      # @example Research the domain example.com:
      #   client.domains.domain_research_status(1010, "example.com")
      #
      # @param  account_id [Integer] the account ID
      # @param  domain_name [#to_s] the domain name to research
      # @param  options [Hash]
      # @return [Dnsimple::Response<Dnsimple::Struct::DomainResearchStatus>]
      #
      # @raise  [Dnsimple::RequestError] When the request fails.
      def domain_research_status(account_id, domain_name, options = {})
        endpoint = Client.versioned("/%s/domains/research/status" % [account_id])
        options = options.merge(query: { domain: domain_name })
        response = client.get(endpoint, options)

        Dnsimple::Response.new(response, Struct::DomainResearchStatus.new(response["data"]))
      end
    end
  end
end
