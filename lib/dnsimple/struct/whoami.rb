# frozen_string_literal: true

module Dnsimple
  module Struct
    class Whoami < Base
      # @return [Account] The account, if present.
      attr_reader :account

      # @return [String] The user, if present.
      attr_reader :user


      # Converts account to a Struct::Account and sets it.
      #
      # @param  [Hash, nil] account
      # @return [void]
      def account=(account)
        @account = account ? Struct::Account.new(account) : account
      end

      # Converts user to a Struct::User and sets it.
      #
      # @param  [Hash, nil] user
      # @return [void]
      def user=(user)
        @user = user ? Struct::User.new(user) : user
      end
    end
  end
end
