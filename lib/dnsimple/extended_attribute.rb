module DNSimple #:nodoc:
  # Used for domains that require extended attributes.
  class ExtendedAttribute
    # An option for an extended attribute
    class Option
      # The option name
      attr_accessor :title

      # The option value
      attr_accessor :value

      # A long description of the option
      attr_accessor :description

      #:nodoc:
      def initialize(attributes)
        attributes.each do |key, value|
          m = "#{key}=".to_sym
          self.send(m, value) if self.respond_to?(m)
        end
      end
    end

    include HTTParty

    # The extended attribute name
    attr_accessor :name

    # A description of the extended attribute
    attr_accessor :description

    # Boolean indicating if the extended attribute is required
    attr_accessor :required

    #:nodoc:
    def initialize(attributes)
      attributes.each do |key, value|
        m = "#{key}=".to_sym
        self.send(m, value) if self.respond_to?(m)
      end
    end

    # An array of options for the extended attribute 
    def options
      @options ||= []
    end

    def options=(opts)
      @options = []
      opts.each do |opt|
        @options << Option.new(opt)
      end
    end

    # Find the extended attributes for the given TLD
    def self.find(tld, options={})
      options.merge!({:basic_auth => Client.credentials})
      options.merge!({:headers => {'Accept' => 'application/json'}})
      
      response = self.get("#{Client.base_uri}/extended_attributes/#{tld}", options)

      pp response if Client.debug?

      case response.code
      when 200
        response.map { |r| ExtendedAttribute.new(r) }
      when 401
        raise RuntimeError, "Authentication failed"
      else
        raise RuntimeError, "Error: #{response.code}"
      end
    end
  end
end
