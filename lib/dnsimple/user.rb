module DNSimple
  class User < Base

    attr_accessor :id
    attr_accessor :email
    attr_accessor :domain_count
    attr_accessor :domain_limit
    attr_accessor :login_count
    attr_accessor :failed_login_count
    attr_accessor :created_at
    attr_accessor :updated_at


    def self.me
      response = DNSimple::Client.get("/users/me")

      case response.code
      when 200
        new(response["user"])
      else
        raise RequestError.new("Error finding account", response)
      end
    end

  end
end
