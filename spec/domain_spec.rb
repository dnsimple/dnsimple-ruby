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
