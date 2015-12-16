module Dnsimple
  class Client
    module Domains

      # Lists the domains in the account.
      #
      # @see https://developer.dnsimple.com/v2/domains/#list
      #
      # @param  [Hash] options the filtering and sorting option
      # @return [Array<Struct::Domain>]
      #
      # @raise  [RequestError] When the request fails.
      def domains(account_id, options = {})
        response = client.get(Client.versioned("/%s/domains" % [account_id]), options)

        response["data"].map { |r| Struct::Domain.new(r) }
      end
      alias :list :domains
      alias :list_domains :domains

    end
  end
end