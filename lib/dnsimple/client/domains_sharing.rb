module Dnsimple
  class Client
    module DomainsSharing

      # Lists the memberships.
      #
      # @see http://developer.dnsimple.com/domains/sharing/#list
      #
      # @param  [#to_s] domain The domain id or domain name.
      # @return [Array<Struct::Membership>]
      #
      # @raise  [NotFoundError]
      # @raise  [RequestError] When the request fails.
      def memberships(domain, options = {})
        response = client.get("v1/domains/#{domain}/memberships", options)

        response.map { |r| Struct::Membership.new(r["membership"]) }
      end
      alias :list_memberships :memberships

      # Shares a domain.
      #
      # @see http://developer.dnsimple.com/domains/sharing/#create
      #
      # @param  [#to_s] domain The domain id or domain name.
      # @param  [String] email
      # @return [Struct::Membership]
      #
      # @raise  [NotFoundError]
      # @raise  [RequestError] When the request fails.
      def create_membership(domain, email, options = {})
        options  = options.merge({ membership: { email: email }})
        response = client.post("v1/domains/#{domain}/memberships", options)

        Struct::Membership.new(response["membership"])
      end

      # Un-shares a domain.
      #
      # @see http://developer.dnsimple.com/domains/sharing/#delete
      #
      # @param  [#to_s] domain The domain id or domain name.
      # @param  [Fixnum] membership The membership id.
      # @return [void]
      #
      # @raise  [NotFoundError]
      # @raise  [RequestError] When the request fails.
      def delete_membership(domain, membership, options = {})
        client.delete("v1/domains/#{domain}/memberships/#{membership}", options)
      end

    end
  end
end
