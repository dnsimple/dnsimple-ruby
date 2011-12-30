class DNSimple::User < DNSimple::Base
  attr_accessor :id

  attr_accessor :created_at

  attr_accessor :updated_at

  attr_accessor :email

  attr_accessor :login_count

  attr_accessor :failed_login_count

  attr_accessor :domain_count

  attr_accessor :domain_limit

  def self.me(options={})
    response = DNSimple::Client.get("users/me.json", options)

    case response.code
    when 200
      return new(response["user"])
    when 404
      raise DNSimple::UserNotFound, "Could not find user"
    else
      raise DNSimple::Error, "Error: #{response.code} #{response.message}"
    end
  end
end
