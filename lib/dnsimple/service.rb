module Dnsimple

  class Service < Base
    # @return [Fixnum] The service ID in DNSimple.
    attr_accessor :id

    # @return [String] The service name.
    attr_accessor :name

    # @return [String] The URI-compatible slug.
    attr_accessor :short_name

    # @return [String] The description.
    attr_accessor :description
  end

end
