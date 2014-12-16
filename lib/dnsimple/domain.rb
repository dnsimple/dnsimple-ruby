module Dnsimple

  class Domain < Base
    # The Fixnum domain ID in DNSimple.
    attr_accessor :id

    # The Fixnum associated user ID.
    attr_accessor :user_id

    # The Fixnum associated registrant ID.
    attr_accessor :registrant_id

    # The String name.
    attr_accessor :name

    # The String state.
    attr_accessor :state

    # The String API token
    attr_accessor :token

    # Is the domain set to auto renew?
    attr_accessor :auto_renew

    # Is the whois information protected?
    attr_accessor :whois_protected

    # The Date the domain will expire.
    attr_accessor :expires_on

    # The Date the domain was created in DNSimple.
    attr_accessor :created_at

    # The Date the domain was last update in DNSimple.
    attr_accessor :updated_at

  end

end
