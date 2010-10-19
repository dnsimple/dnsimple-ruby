require 'spec_helper'

describe DNSimple::Contact do
  describe "a new contact" do
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
    before do
      @contact = DNSimple::Contact.create(contact_attributes)
    end
    after do
      @contact.delete
    end
    it "has specific attributes" do
      @contact.first_name.should eql(contact_attributes[:first_name])
      @contact.id.should_not be_nil
    end
    it "can be found by id" do
      contact = DNSimple::Contact.find(@contact.id)
    end
  end
end
