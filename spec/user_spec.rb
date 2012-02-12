describe DNSimple::User do
  describe ".me" do
    use_vcr_cassette
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
end
