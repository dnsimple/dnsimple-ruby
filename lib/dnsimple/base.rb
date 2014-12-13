module Dnsimple
  class Base
    def initialize(attributes = {})
      attributes.each do |key, value|
        m = "#{key}=".to_sym
        self.send(m, value) if self.respond_to?(m)
      end
    end
  end
end
