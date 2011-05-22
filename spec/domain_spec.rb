require File.join(File.dirname(__FILE__), 'spec_helper')

describe DNSimple::Domain do
  describe "creating a new domain" do
    use_vcr_cassette
    it "has specific attributes" do 
      @domain = DNSimple::Domain.create("testdomain.com")
      @domain.name.should eql("testdomain.com")
      @domain.id.should_not be_nil
    end
  end
  describe "finding an existing domain" do
    context "by id" do
      use_vcr_cassette
      it "can be found" do
        domain = DNSimple::Domain.find(141)
        domain.name.should eql("testdomain.com")
        domain.id.should_not be_nil
      end
    end
    context "by name" do
      use_vcr_cassette
      it "can be found" do
        domain = DNSimple::Domain.find("testdomain.com")
        domain.name.should eql("testdomain.com")
        domain.id.should_not be_nil
      end
    end
  end

  context "registration" do
    let(:name) { "testdomain.net" }

    context "with an existing contact" do
      use_vcr_cassette
      it "can be registered" do
        domain = DNSimple::Domain.register(name, {:id => 4})
        domain.name.should eql(name)
      end
    end
    
    context "with a new registrant contact" do
      use_vcr_cassette
      it "can be registered" do
        registrant = {
          :first_name => 'John',
          :last_name => 'Smith',
          :address1 => '123 SW 1st Street',
          :city => 'Miami',
          :state_or_province => 'FL',
          :country => 'US',
          :postal_code => '33143',
          :phone => '321 555 1212'
        }
        domain = DNSimple::Domain.register(name, registrant)
        domain.name.should eql(name)
      end
    end
  end

  describe ".all" do
    use_vcr_cassette
    before do
      @domains = []
      3.times do |n|
        @domains << DNSimple::Domain.create("testdomain#{n}.com")
      end
    end
    it "returns a list of domains" do
      domains = DNSimple::Domain.all
      domains.map { |d| d.name }.should include(*@domains.map { |d| d.name })
    end
  end

  describe "applying templates" do
    use_vcr_cassette
    before do
      @domain = DNSimple::Domain.find("testdomain.com")
    end
    it "applies a named template" do
      DNSimple::Record.all(@domain.name).should be_empty
      @domain.apply("googleapps")
      DNSimple::Record.all(@domain.name).should_not be_empty
    end
  end
end
