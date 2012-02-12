describe DNSimple::Domain do
  let(:domain_name) { "example.com" }
  let(:contact_id) { 1 }

  describe "creating a new domain" do
    use_vcr_cassette
    it "has specific attributes" do 
      @domain = DNSimple::Domain.create(domain_name)
      @domain.name.should eql(domain_name)
      @domain.id.should_not be_nil
    end
  end
  describe "finding an existing domain" do
    context "by id" do
      use_vcr_cassette
      it "can be found" do
        domain = DNSimple::Domain.find(39)
        domain.name.should eql(domain_name)
        domain.id.should_not be_nil
      end
    end
    context "by name" do
      use_vcr_cassette
      it "can be found" do
        domain = DNSimple::Domain.find(domain_name)
        domain.name.should eql(domain_name)
        domain.id.should_not be_nil
      end
    end
  end

  context "registration" do

    context "with an existing contact" do
      let(:domain_name) { "dnsimple-example-1321042237.com" }
      use_vcr_cassette
      it "can be registered" do
        domain = DNSimple::Domain.register(domain_name, {:id => contact_id})
        domain.name.should eql(domain_name)
      end
    end
    
    context "with a new registrant contact" do
      let(:domain_name) { "dnsimple-example-1321042288.com" }
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
        domain = DNSimple::Domain.register(domain_name, registrant)
        domain.name.should eql(domain_name)
      end
    end
  end

  describe ".all" do
    use_vcr_cassette
    before do
      @domains = []
      2.times do |n|
        @domains << DNSimple::Domain.create("example#{n}.com")
      end
    end
    it "returns a list of domains" do
      domains = DNSimple::Domain.all
      domains.map { |d| d.name }.should include(*@domains.map { |d| d.name })
    end
  end

  describe "applying templates" do
    use_vcr_cassette
    let(:domain) { DNSimple::Domain.find("example.com") }
    it "applies a named template" do
      DNSimple::Record.all(domain).should be_empty
      domain.apply("googleapps")
      DNSimple::Record.all(domain).should_not be_empty
    end
  end
end
