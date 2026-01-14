# frozen_string_literal: true

module Dnsimple
  class Client
    module Billing
      # List the billing charges for the account.
      #
      # @see https://developer.dnsimple.com/v2/billing/#listCharges
      #
      # @example List charges in the first page
      #   client.charges.list(1010)
      #
      # @example List charges, provide a filter start date
      #   client.charges.list(1010, filter: { start_date: "2023-01-01" })
      #
      # @example List charges, provide a sorting policy
      #   client.charges.list(1010, sort: "invoiced:asc")
      #
      # @param  account_id [Integer] the account ID
      # @param  options [Hash] the filtering and sorting options
      # @option options [Integer] :page current page (pagination)
      # @option options [Integer] :per_page number of entries to return (pagination)
      # @option options [String] :sort sorting policy
      # @return [Dnsimple::PaginatedResponse<Dnsimple::Struct::Charge>]
      #
      # @raise  [Dnsimple::RequestError]
      def charges(account_id, options = {})
        response = client.get(Client.versioned("/%s/billing/charges" % [account_id]), Options::ListOptions.new(options))

        Dnsimple::PaginatedResponse.new(response, response["data"].map { |r| Struct::Charge.new(r) })
      end
      alias list_charges charges
    end
  end
end
