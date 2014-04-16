module DNSimple

  class Error < StandardError
  end

  class RecordExists < Error
  end

  class RecordNotFound < Error
  end

  class RequestError < Error
    def initialize(description, response)
      super("#{description}: #{response["errors"]}")
    end
  end

  class AuthenticationFailed < Error
  end

end
