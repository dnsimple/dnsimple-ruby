module DNSimple

  # Used for domains that require extended attributes.
  class ExtendedAttribute < Base

    # An option for an extended attribute
    class Option < Base
      # The option name
      attr_accessor :title

      # The option value
      attr_accessor :value

      # A long description of the option
      attr_accessor :description
    end

    # The extended attribute name
    attr_accessor :name

    # A description of the extended attribute
    attr_accessor :description

    # Boolean indicating if the extended attribute is required
    attr_accessor :required

    # An array of options for the extended attribute
    def options
      @options ||= []
    end

    def options=(opts)
      @options = []
      opts.each do |opt|
        @options << DNSimple::ExtendedAttribute::Option.new(opt)
      end
    end

    # Find the extended attributes for the given TLD
    def self.find(tld, options={})
      response = DNSimple::Client.get "extended_attributes/#{tld}.json", options

      case response.code
      when 200
        response.map { |r| new(r) }
      else
        raise RequestError, "Error finding extended attributes", response
      end
    end

  end
end
