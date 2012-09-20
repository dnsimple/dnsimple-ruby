module DNSimple

  class Error < StandardError
  end

  class DomainError < Error
    def initialize(domain, messages)
      @domain = domain
      @messages = messages
      super "An error occurred: #{messages}"
    end
  end

  class RecordExists < DomainError
    def initialize(domain, message)
      super(domain, message)
    end
  end

  class RecordNotFound < Error
  end

  class AuthenticationFailed < Error
  end

  class UserNotFound < Error
  end

  class CertificateExists < Error
  end

  class CertificateNotFound < Error
  end

end
