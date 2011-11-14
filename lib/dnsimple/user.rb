module DNSimple
  class User
    include HTTParty

    attr_accessor :id

    attr_accessor :created_at

    attr_accessor :updated_at

    attr_accessor :email

    attr_accessor :login_count

    attr_accessor :failed_login_count

    attr_accessor :domain_count

    attr_accessor :domain_limit

    def initialize(attributes)
      attributes.each do |key, value|
        m = "#{key}=".to_sym
        self.send(m, value) if self.respond_to?(m)
      end
    end

    def self.me(options={})
      options.merge!({:basic_auth => Client.credentials})
      response = self.get("#{Client.base_uri}/users/me.json", options)

      case response.code
      when 200
        return User.new(response["user"])
      when 401
        raise DNSimple::AuthenticationFailed, "Authentication failed"
      when 404
        raise DNSimple::UserNotFound, "Could not find user"
      else
        raise DNSimple::Error, "Error: #{response.code} #{response.message}"
      end
    end
  end
end
