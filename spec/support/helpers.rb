module RSpecSupportHelpers

  def fixture(*names)
    File.join(SPEC_ROOT, "files", *names)
  end

  def read_fixture(*names)
    File.read(fixture(*names))
  end

end

RSpec.configure do |config|
  config.include RSpecSupportHelpers
end
