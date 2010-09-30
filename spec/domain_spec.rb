require File.join(File.dirname(__FILE__), 'spec_helper')

describe DNSimple::Domain do

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
    it "can be found by id" do
      domain = DNSimple::Domain.find(@domain.id)
      domain.name.should eql("testdomain.com")
      domain.id.should_not be_nil
    end
    it "can be found by name" do
      domain = DNSimple::Domain.find(@domain.name)
      domain.name.should eql("testdomain.com")
      domain.id.should_not be_nil
    end
  end

  context "registration" do
    describe "a new domain" do
      context "with an existing contact" do
        let(:name) { "testdomain-#{Time.now.to_i}.net" }
        let(:registrant) { Hash.new(:id => 4) }
        it "can be registered" do
          domain = DNSimple::Domain.register(name, registrant)
          domain.name.should eql(name)
        end
      end
      context "with a new registrant contact" do
        let(:name) { "testdomain-#{Time.now.to_i}.net" }
        it "can be registered" do
          registrant = {
            :first_name => 'John',
            :last_name => 'Smith',
            :address1 => '123 SW 1st Street',
            :city => 'Miami',
            :state_or_province => 'FL',
            :country => 'US',
            :postal_code => '33143'
          }
          domain = DNSimple::Domain.register(name, registrant)
          domain.name.should eql(name)
        end
      end
    end
  end

  describe ".all" do
    before do
      @domains = []
      3.times do |n|
        @domains << DNSimple::Domain.create("testdomain#{n}.com")
      end
    end
    after do
      @domains.each { |d| d.destroy }
    end
    it "returns a list of domains" do
      domains = DNSimple::Domain.all
      domains.map { |d| d.name }.should include(*@domains.map { |d| d.name })
    end
  end

  describe "applying templates" do
    before do
      @domain = DNSimple::Domain.create("testdomain.com")
    end
    after do
      @domain.delete
    end
    it "applies a named template" do
      DNSimple::Record.all(@domain.name).should be_empty
      @domain.apply("googleapps")
      DNSimple::Record.all(@domain.name).should_not be_empty
    end
  end
end
