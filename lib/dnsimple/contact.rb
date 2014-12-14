module Dnsimple

  class Contact < Base

    # @return [Symbol] The contact ID in DNSimple.
    attr_accessor :id

    # @return [Symbol] The label to represent the contact.
    attr_accessor :label

    # @return [Symbol] The contact first name.
    attr_accessor :first_name

    # @return [Symbol] The contact last name.
    attr_accessor :last_name

    # @return [Symbol] The contact's job title.
    attr_accessor :job_title

    # @return [Symbol] The name of the organization in which the contact works.
    attr_accessor :organization_name

    # @return [Symbol] The contact street address.
    attr_accessor :address1

    # @return [Symbol] Apartment or suite number.
    attr_accessor :address2

    # @return [Symbol] The city name.
    attr_accessor :city

    # @return [Symbol] The state or province name.
    attr_accessor :state_province

    # @return [Symbol] The contact postal code.
    attr_accessor :postal_code

    # @return [Symbol] The contact country (as a 2-character country code).
    attr_accessor :country

    # @return [Symbol] The contact phone number.
    attr_accessor :phone

    # @return [Symbol] The contact fax number (may be omitted).
    attr_accessor :fax

    # @return [Symbol] The contact email address.
    attr_accessor :email_address

    # @return [Symbol] When the contact was created in DNSimple.
    attr_accessor :created_at

    # @return [Symbol] When the contact was last updated in DNSimple.
    attr_accessor :updated_at

    alias :email :email_address
    alias :email= :email_address=
  end

end
