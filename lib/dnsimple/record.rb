module DNSimple
  class Record
    include HTTParty

    attr_accessor :id

    attr_accessor :domain

    attr_accessor :name

    attr_accessor :content

    attr_accessor :record_type

    attr_accessor :ttl

    attr_accessor :prio

    #:nodoc:
    def initialize(attributes)
      attributes.each do |key, value|
        m = "#{key}=".to_sym
        self.send(m, value) if self.respond_to?(m)
      end
    end

    def fqdn
      [name, domain.name].delete_if { |v| v.blank? }.join(".")
    end

    def save(options={})
      record_hash = {}
      %w(name content ttl prio).each do |attribute|
        record_hash[DNSimple::Record.resolve(attribute)] = self.send(attribute)
      end

      options.merge!(DNSimple::Client.standard_options_with_credentials)
      options.merge!(:body => {:record => record_hash})

      response = self.class.put("#{DNSimple::Client.base_uri}/domains/#{domain.id}/records/#{id}.json", options)

      pp response if DNSimple::Client.debug?

      case response.code
      when 200
        return self
      when 401
        raise RuntimeError, "Authentication failed"
      else
        raise RuntimeError, "Failed to update record: #{response.inspect}" 
      end
    end
    
    def delete(options={})
      options.merge!(DNSimple::Client.standard_options_with_credentials)
      self.class.delete("#{DNSimple::Client.base_uri}/domains/#{domain.id}/records/#{id}", options)
    end
    alias :destroy :delete

    def self.resolve(name)
      aliases = {
        'priority' => 'prio',
        'time-to-live' => 'ttl'
      }
      aliases[name] || name
    end

    def self.create(domain_name, name, record_type, content, options={})
      domain = DNSimple::Domain.find(domain_name)
      
      record_hash = {:name => name, :record_type => record_type, :content => content}
      record_hash[:ttl] = options.delete(:ttl) || 3600
      record_hash[:prio] = options.delete(:priority)
      record_hash[:prio] = options.delete(:prio) || ''
      
      options.merge!(DNSimple::Client.standard_options_with_credentials)
      options.merge!({:query => {:record => record_hash}})

      response = self.post("#{DNSimple::Client.base_uri}/domains/#{domain.id}/records", options) 

      pp response if DNSimple::Client.debug?

      case response.code
      when 201
        return DNSimple::Record.new({:domain => domain}.merge(response["record"]))
      when 401
        raise RuntimeError, "Authentication failed"
      when 406
        raise DNSimple::RecordExists.new("#{name}.#{domain_name}", response["errors"])
      else
        raise DNSimple::Error.new("#{name}.#{domain_name}", response["errors"])
      end
    end

    def self.find(domain_name, id, options={})
      domain = DNSimple::Domain.find(domain_name)
      options.merge!(DNSimple::Client.standard_options_with_credentials)
      response = self.get("#{DNSimple::Client.base_uri}/domains/#{domain.id}/records/#{id}", options)

      pp response if DNSimple::Client.debug?

      case response.code
      when 200
        return DNSimple::Record.new({:domain => domain}.merge(response["record"]))
      when 401
        raise RuntimeError, "Authentication failed"
      when 404
        raise RuntimeError, "Could not find record #{id} for domain #{domain_name}"
      else
        raise DNSimple::Error.new("#{domain_name}/#{id}", response["errors"])
      end
    end

    def self.all(domain_name, options={})
      domain = DNSimple::Domain.find(domain_name)
      options.merge!(DNSimple::Client.standard_options_with_credentials)
      response = self.get("#{DNSimple::Client.base_uri}/domains/#{domain.id}/records", options)

      pp response if DNSimple::Client.debug?

      case response.code
      when 200
        response.map { |r| DNSimple::Record.new({:domain => domain}.merge(r["record"])) }
      when 401
        raise RuntimeError, "Authentication failed"
      else
        raise RuntimeError, "Error: #{response.code}"
      end
    end

  end
end
