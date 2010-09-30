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

    def delete(options={})
      options.merge!(:basic_auth => Client.credentials)
      self.class.delete("#{Client.base_uri}/templates/#{template.id}/template_records/#{id}.json", options)
    end
    alias :destroy :delete

    def self.create(short_name, name, record_type, content, options={})
      template = Template.find(short_name)

      record_hash = {:name => name, :record_type => record_type, :content => content}
      record_hash[:ttl] = options.delete(:ttl) || 3600
      record_hash[:prio] = options.delete(:prio) || ''

      options.merge!({:query => {:dns_template_record => record_hash}})
      options.merge!({:basic_auth => Client.credentials})

      response = self.post("#{Client.base_uri}/templates/#{template.id}/template_records.json", options)

      pp response if Client.debug?

      case response.code
      when 201
        return TemplateRecord.new({:template => template}.merge(response["dns_template_record"]))
      when 401
        raise RuntimeError, "Authentication failed"
      else
        raise DNSimple::Error.new("#{name}", response["errors"])
      end
    end

    def self.find(short_name, id, options={})
      template = Template.find(short_name)
      options.merge!(:basic_auth => Client.credentials)
      response = self.get("#{Client.base_uri}/templates/#{template.id}/template_records/#{id}.json", options)

      pp response if Client.debug?

      case response.code
      when 200
        return TemplateRecord.new({:template => template}.merge(response["dns_template_record"]))
      when 401
        raise RuntimeError, "Authentication failed"
      when 404
        raise RuntimeError, "Could not find template record #{id} for template #{short_name}"
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
