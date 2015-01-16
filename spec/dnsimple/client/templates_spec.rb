require 'spec_helper'

describe Dnsimple::Client, ".templates" do

  subject { described_class.new(api_endpoint: "https://api.zone", username: "user", api_token: "token").templates }


  describe "#list" do
    before do
      stub_request(:get, %r[/v1/templates$]).
          to_return(read_fixture("templates/index/success.http"))
    end

    it "builds the correct request" do
      subject.list

      expect(WebMock).to have_requested(:get, "https://api.zone/v1/templates").
                         with(headers: { 'Accept' => 'application/json' })
    end

    it "returns the templates" do
      results = subject.list

      expect(results).to be_a(Array)
      expect(results.size).to eq(1)

      results.each do |result|
        expect(result).to be_a(Dnsimple::Struct::Template)
        expect(result.id).to be_a(Fixnum)
      end
    end
  end

  describe "#create" do
    before do
      stub_request(:post, %r[/v1/templates]).
          to_return(read_fixture("templates/create/created.http"))
    end

    let(:attributes) { { name: "", short_name: "" } }

    it "builds the correct request" do
      subject.create(attributes)

      expect(WebMock).to have_requested(:post, "https://api.zone/v1/templates").
                         with(body: { dns_template: attributes }).
                         with(headers: { 'Accept' => 'application/json' })
    end

    it "returns the template" do
      result = subject.create(attributes)

      expect(result).to be_a(Dnsimple::Struct::Template)
      expect(result.id).to be_a(Fixnum)
    end
  end

  describe "#find" do
    before do
      stub_request(:get, %r[/v1/templates/.+$]).
          to_return(read_fixture("templates/show/success.http"))
    end

    it "builds the correct request" do
      subject.find(1)

      expect(WebMock).to have_requested(:get, "https://api.zone/v1/templates/1").
                             with(headers: { 'Accept' => 'application/json' })
    end

    it "returns the template" do
      result = subject.find(1)

      expect(result).to be_a(Dnsimple::Struct::Template)
      expect(result.id).to eq(2651)
      expect(result.name).to eq("Localhost")
      expect(result.short_name).to eq("localhost")
      expect(result.description).to eq("This is a test.")
    end

    context "when something does not exist" do
      it "raises NotFoundError" do
        stub_request(:get, %r[/v1]).
            to_return(read_fixture("templates/notfound.http"))

        expect {
          subject.find(1)
        }.to raise_error(Dnsimple::NotFoundError)
      end
    end
  end

  describe "#update" do
    before do
      stub_request(:put, %r[/v1/templates/.+$]).
          to_return(read_fixture("templates/update/success.http"))
    end

    it "builds the correct request" do
      subject.update(1, { name: "Updated" })

      expect(WebMock).to have_requested(:put, "https://api.zone/v1/templates/1").
                             with(body: { dns_template: { name: "Updated" } }).
                             with(headers: { 'Accept' => 'application/json' })
    end

    it "returns the template" do
      result = subject.update(1, {})

      expect(result).to be_a(Dnsimple::Struct::Template)
      expect(result.id).to be_a(Fixnum)
    end

    context "when something does not exist" do
      it "raises NotFoundError" do
        stub_request(:put, %r[/v1]).
            to_return(read_fixture("templates/notfound.http"))

        expect {
          subject.update(1, {})
        }.to raise_error(Dnsimple::NotFoundError)
      end
    end
  end

  describe "#delete" do
    before do
      stub_request(:delete, %r[/v1/templates/.+$]).
          to_return(read_fixture("templates/delete/success.http"))
    end

    it "builds the correct request" do
      subject.delete(1)

      expect(WebMock).to have_requested(:delete, "https://api.zone/v1/templates/1").
                         with(headers: { 'Accept' => 'application/json' })
    end

    it "returns nothing" do
      result = subject.delete(1)

      expect(result).to be_truthy
    end

    it "supports HTTP 204" do
      stub_request(:delete, %r[/v1]).
          to_return(read_fixture("templates/delete/success-204.http"))

      result = subject.delete(1)

      expect(result).to be_truthy
    end

    context "when something does not exist" do
      it "raises NotFoundError" do
        stub_request(:delete, %r[/v1]).
            to_return(read_fixture("templates/notfound.http"))

        expect {
          subject.delete(1)
        }.to raise_error(Dnsimple::NotFoundError)
      end
    end
  end


  describe "#apply" do
    before do
      stub_request(:post, %r[/v1/domains/.+/templates/.+/apply$]).
          to_return(read_fixture("templates/apply/success.http"))
    end

    it "builds the correct request" do
      subject.apply(1, 2)

      expect(WebMock).to have_requested(:post, "https://api.zone/v1/domains/1/templates/2/apply").
                             with(headers: { 'Accept' => 'application/json' })
    end

    it "returns nothing" do
      result = subject.apply(1, 2)

      expect(result).to be_truthy
    end

    context "when something does not exist" do
      it "raises NotFoundError" do
        stub_request(:post, %r[/v1]).
            to_return(read_fixture("templates/notfound.http"))

        expect {
          subject.apply(1, 2)
        }.to raise_error(Dnsimple::NotFoundError)
      end
    end
  end

end
