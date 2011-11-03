require File.join(File.dirname(__FILE__), 'spec_helper')

describe DNSimple::Record do

  let(:domain) { DNSimple::Domain.new(:name => 'example.com') }

  describe "#fqdn" do
    it "joins the name and domain name" do
      record = DNSimple::Record.new(:name => 'www', :domain => domain)
      record.fqdn.should eq('www.example.com')
    end
    it "strips a blank name" do
      record = DNSimple::Record.new(:name => '', :domain => domain)
      record.fqdn.should eq('example.com')
    end
  end

  describe "creating a new record" do
    use_vcr_cassette
    it "has specific attributes" do 
      record = DNSimple::Record.create('testdomain.com', "", "A", "1.2.3.4", :ttl => 600)
      record.name.should eql("")
      record.record_type.should eql("A")
      record.content.should eql("1.2.3.4")
      record.ttl.should eql(600)
      record.id.should_not be_nil
    end
  end
  describe "find a record" do
    use_vcr_cassette
    it "can be found by id" do
      record = DNSimple::Record.find('testdomain.com', 193)
      record.name.should eql("")
      record.record_type.should eql("A")
      record.content.should eql("1.2.3.4")
      record.ttl.should eql(600)
      record.id.should_not be_nil
    end
  end

  describe ".all" do
    use_vcr_cassette
    before do
      @records = []
      
      @records << DNSimple::Record.create("testdomain.com", "", "A", "4.5.6.7")
      @records << DNSimple::Record.create("testdomain.com", "www", "CNAME", "testdomain.com")
      @records << DNSimple::Record.create("testdomain.com", "", "MX", "mail.foo.com", :prio => 10)
    end
    
    it "returns a list of records" do
      records = DNSimple::Record.all('testdomain.com')
      records.should_not be_empty
      records.length.should eql(@records.length)
    end
  end
end

