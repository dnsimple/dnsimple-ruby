module Dnsimple

  # {Client} backwards compatibility
  module Compatibility
    def self.included(base)
      base.extend ClassMethods
      base.class_eval do
        class << self
          attr_accessor :base_uri, :username, :password, :exchange_token, :api_token, :domain_api_token
        end
      end
    end

    module ClassMethods
      def client
        options = {}
        options[:api_endpoint] = base_uri if base_uri
        options[:username] = username if username
        options[:password] = password if password
        options[:api_token] = api_token if api_token
        options[:domain_api_token] = domain_api_token if domain_api_token
        options[:exchange_token] = exchange_token if exchange_token

        new(options)
      end

      def get(*args)
        client.get(*args)
      end

      def post(*args)
        client.post(*args)
      end

      def put(*args)
        client.put(*args)
      end

      def delete(*args)
        client.delete(*args)
      end
    end

  end

end