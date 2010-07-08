require File.join(File.dirname(__FILE__), 'spec_helper')

describe DNSimple::Domain do
  before do
    DNSimple::Client.debug = true 
    DNSimple::Client.credentials('anthonyeden@gmail.com', 'letmein')
  end

  describe "a new domain" do
    before do
      @domain = DNSimple::Domain.create("testdomain.com")
    end
    after do
      @domain.delete
    end
    it "has specific attributes" do 
      @domain.name.should eql("testdomain.com")
      @domain.id.should_not be_nil
    end
    it "can be found" do
      domain = DNSimple::Domain.find(@domain.id)
      domain.name.should eql("testdomain.com")
      domain.id.should_not be_nil
    end
  end
end
