# frozen_string_literal: true

module Dnsimple
  module Struct
    class OauthToken < Base
      # @return [String] The token you can use to authenticate.
      attr_accessor :access_token

      # @return [String] The token type.
      attr_accessor :token_type

      # @return [String] The token scope (not used for now).
      attr_accessor :scope

      # @return [Integer] The account ID in DNSimple this token belongs to.
      attr_accessor :account_id
    end
  end
end
