require 'spec_helper'

describe Dnsimple::Client, ".templates / domains" do

  subject { described_class.new(api_endpoint: "https://api.zone", username: "user", api_token: "token").templates }

  describe "#apply_template" do
    before do
      stub_request(:post, %r[/v1/domains/.+/templates/.+/apply$]).
          to_return(read_fixture("templates/apply_template/success.http"))
    end

    it "builds the correct request" do
      subject.apply(1, 2)

      expect(WebMock).to have_requested(:post, "https://api.zone/v1/domains/1/templates/2/apply").
                             with(headers: { 'Accept' => 'application/json' })
    end

    it "returns nothing" do
      result = subject.apply_template(1, 2)

      expect(result).to be_truthy
    end

    context "when something does not exist" do
      it "raises NotFoundError" do
        stub_request(:post, %r[/v1]).
            to_return(read_fixture("templates/notfound-template.http"))

        expect {
          subject.apply_template(1, 2)
        }.to raise_error(Dnsimple::NotFoundError)
      end
    end
  end

end
