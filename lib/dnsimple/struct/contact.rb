# frozen_string_literal: true

module Dnsimple
  module Struct

    class Contact < Base
      # @return [Integer] The contact ID in DNSimple.
      attr_accessor :id

      # @return [Integer] The associated account ID.
      attr_accessor :account_id

      # @return [String] The label to represent the contact.
      attr_accessor :label

      # @return [String] The contact first name.
      attr_accessor :first_name

      # @return [String] The contact last name.
      attr_accessor :last_name

      # @return [String] The contact's job title.
      attr_accessor :job_title

      # @return [String] The name of the organization in which the contact works.
      attr_accessor :organization_name

      # @return [String] The contact street address.
      attr_accessor :address1

      # @return [String] Apartment or suite number.
      attr_accessor :address2

      # @return [String] The city name.
      attr_accessor :city

      # @return [String] The state or province name.
      attr_accessor :state_province

      # @return [String] The contact postal code.
      attr_accessor :postal_code

      # @return [String] The contact country (as a 2-character country code).
      attr_accessor :country

      # @return [String] The contact phone number.
      attr_accessor :phone

      # @return [String] The contact fax number (may be omitted).
      attr_accessor :fax

      # @return [String] The contact email address.
      attr_accessor :email

      # @return [String] When the contact was created in DNSimple.
      attr_accessor :created_at

      # @return [String] When the contact was last updated in DNSimple.
      attr_accessor :updated_at
    end

  end
end
