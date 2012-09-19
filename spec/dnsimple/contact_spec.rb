require 'spec_helper'

describe DNSimple::Contact do

  describe "a new contact" do
    use_vcr_cassette

    let(:contact_attributes) {
      {
        :first_name => 'John',
        :last_name => 'Doe',
        :address1 => '1 SW 1st Street',
        :city => 'Miami',
        :state_province => 'FL',
        :postal_code => '33143',
        :country => 'US',
        :email_address => 'john.doe@example.com',
        :phone => '305 111 2222'
      }
    }
    it "has specific attributes" do
      contact = DNSimple::Contact.create(contact_attributes)
      contact.first_name.should eql(contact_attributes[:first_name])
      contact.id.should_not be_nil
    end
  end

  describe "an existing contact" do
    use_vcr_cassette

    it "can be found by id" do
      contact = DNSimple::Contact.find(1)
      contact.should_not be_nil
    end
  end

end
