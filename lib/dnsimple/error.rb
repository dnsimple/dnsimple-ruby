module DNSimple

  class Error < StandardError
  end

  class RecordExists < Error
  end

  class RecordNotFound < Error
  end

  class RequestError < Error
    def initialize(description, response)
      error = response["errors"].size > 0 ? response["errors"] : response["warning"]
      super("#{description}: #{error} (#{response.code})")
    end
  end

  class AuthenticationFailed < Error
  end

end
