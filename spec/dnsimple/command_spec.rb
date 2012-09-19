require 'spec_helper'
require 'dnsimple/command'

class FakeCommand < DNSimple::Command
  def execute
    say "done"
  end
end

describe DNSimple::Command do
  describe "#say" do
    it "writes to the output" do
      s = StringIO.new
      command = FakeCommand.new(s)
      command.execute
      s.string.should eq("done\n")
    end
  end
end
