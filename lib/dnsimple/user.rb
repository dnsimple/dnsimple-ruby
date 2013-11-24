module DNSimple
  class User < Base

    attr_accessor :id

    attr_accessor :created_at

    attr_accessor :updated_at

    attr_accessor :email

    attr_accessor :login_count

    attr_accessor :failed_login_count

    attr_accessor :domain_count

    attr_accessor :domain_limit

    def self.me(options={})
      response = DNSimple::Client.get("users/me", options)

      case response.code
      when 200
        new(response["user"])
      when 404
        raise RecordNotFound, "Could not find account with current credentials"
      else
        raise RequestError.new("Error finding account", response)
      end
    end

    def self.register(options={})
      response = DNSimple::Client.post("users", {:no_auth => true, :body => {:user => options}})

      case response.code
      when 400
        raise RequestError.new("Could not register user", response)
      when 201
        new(response["user"])
      end
    end

  end
end
