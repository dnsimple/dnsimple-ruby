module Dnsimple
  module Struct

    class Collaborator < Base
      # @return [Fixnum] The collaborator ID in DNSimple.
      attr_accessor :id

      # @return [Fixnum] The associated domain ID.
      attr_accessor :domain_id

      # @return [String] The associated domain name.
      attr_accessor :domain_name

      # @return [Fixnum,NilClass] The user ID, if the collaborator accepted the invitation.
      attr_accessor :user_id

      # @return [String,NilClass] The user email, if the the invitation is still pending.
      attr_accessor :user_email

      # @return [TrueClass,FalseClass] Invitation
      attr_accessor :invitation

      # @return [String] When the collaborator was created in DNSimple.
      attr_accessor :created_at

      # @return [String] When the collaborator was last updated in DNSimple.
      attr_accessor :updated_at

      # @return [String,NilClass] When the collaborator has accepted the invitation.
      attr_accessor :accepted_at
    end

  end
end
