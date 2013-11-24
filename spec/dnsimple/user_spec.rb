require 'spec_helper'

describe DNSimple::User do
  use_vcr_cassette

  describe ".me" do
    let(:user) { DNSimple::User.me }

    it "returns the current user" do
      user.should_not be_nil
    end
    
    it "has attributes" do
      user.id.should_not be_nil
      user.created_at.should_not be_nil
      user.updated_at.should_not be_nil
      user.email.should_not be_nil
      user.login_count.should_not be_nil
      user.failed_login_count.should_not be_nil
      user.domain_count.should_not be_nil
      user.domain_limit.should_not be_nil
    end
  end

  describe "user registration" do
    let(:email) { 'john.smith@gmail.com' }
    let(:password) { 'x8ejfhfgjQ#A' }

    it "assigns attributes to user" do
      user = DNSimple::User.register(:email => email, :password => password, :password_confirmation => password)
      user.should_not be_nil
      user.id.should_not be_nil
      user.created_at.should_not be_nil
      user.updated_at.should_not be_nil
      user.email.should_not be_nil
      user.login_count.should_not be_nil
      user.failed_login_count.should_not be_nil
      user.domain_count.should_not be_nil
      user.domain_limit.should_not be_nil
    end
  end
end
