module DNSimple #:nodoc:
  # A single record in a template
  class TemplateRecord
    include HTTParty

    # The id of the template record
    attr_accessor :id

    # The template the record belongs to
    attr_accessor :template

    # The name the record points to. This may be blank.
    attr_accessor :name

    # The content for the record.
    attr_accessor :content

    # The record type
    attr_accessor :record_type

    # The time-to-live
    attr_accessor :ttl

    # The priority (only for MX records)
    attr_accessor :prio

    #:nodoc:
    def initialize(attributes)
      attributes.each do |key, value|
        m = "#{key}=".to_sym
        self.send(m, value) if self.respond_to?(m)
      end
    end

    # Get all of the template records for the template with the
    # given short name.
    def self.all(short_name, options={})
      template = Template.find(short_name)
      options.merge!({:basic_auth => Client.credentials})
      response = self.get("#{Client.base_uri}/templates/#{template.id}/template_records.json", options)

      pp response if Client.debug?

      case response.code
      when 200
        response.map { |r| TemplateRecord.new({:template => template}.merge(r["dns_template_record"])) }
      when 401
        raise RuntimeError, "Authentication failed"
      else
        raise RuntimeError, "Error: #{response.code}"
      end
    end
  end


end
