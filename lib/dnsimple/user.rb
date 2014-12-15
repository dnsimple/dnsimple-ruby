module Dnsimple

  class User < Base
    attr_accessor :id
    attr_accessor :email
    attr_accessor :api_token
    attr_accessor :domain_count
    attr_accessor :domain_limit
    attr_accessor :login_count
    attr_accessor :failed_login_count
    attr_accessor :created_at
    attr_accessor :updated_at
  end

end
