# frozen_string_literal: true

module Dnsimple
  class Client
    module Identity
      # Gets the information about the current authenticated context.
      #
      # @see https://developer.dnsimple.com/v2/identity/#whoami
      #
      # @param  options [Hash]
      # @return [Dnsimple::Response<Dnsimple::Struct::Whoami>]
      # @raise  [Dnsimple::RequestError]
      def whoami(options = {})
        response = client.get(Client.versioned("/whoami"), options)

        Dnsimple::Response.new(response, Struct::Whoami.new(response["data"]))
      end


      module StaticHelpers
        # Calls {Identity#whoami} and directly returns the response data.
        #
        # @see https://developer.dnsimple.com/v2/identity/#whoami
        #
        # @param  client [Dnsimple::Client] the DNSimple client instance to use
        # @param  args [Array] the args for the {Identity#whoami} call
        # @return [Hash]
        # @raise  [Dnsimple::RequestError]
        def whoami(client, *)
          client.identity.whoami(*).data
        end
      end
    end
  end
end
