module DNSimple
  class Error < StandardError
    def initialize(domain, messages)
      @domain = domain
      @messages = messages
      super "An error occurred: #{messages.join('. ')}"
    end
  end
end
