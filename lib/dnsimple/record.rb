module DNSimple
  class Record
    include HTTParty
    base_uri 'http://localhost:3000/'

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
    
    def delete(options={})
      options.merge!({:basic_auth => Client.credentials})
      self.class.delete("/domains/#{domain.id}/records/#{id}.json", options)
    end
    alias :destroy :delete

    def self.create(domain_name, name, record_type, content, options={})
      domain = Domain.find(domain_name)
      
      record_hash = {:name => name, :record_type => record_type, :content => content}
      record_hash[:ttl] = options.delete(:ttl) || 3600
      record_hash[:prio] = options.delete(:prio) || ''

      options.merge!({:query => {:record => record_hash}})
      options.merge!({:basic_auth => Client.credentials})

      response = self.post("/domains/#{domain.id}/records.json", options) 

      pp response if Client.debug?

      case response.code
      when 201
        return Record.new({:domain => domain}.merge(response["record"]))
      when 401
        raise RuntimeError, "Authentication failed"
      else
        raise DNSimple::Error.new("#{name}.#{domain_name}", response["errors"])
      end
    end

    def self.find(domain_name, id, options={})
      domain = Domain.find(domain_name)
      options.merge!({:basic_auth => Client.credentials})
      response = self.get("/domains/#{domain.id}/records/#{id}", options)

      pp response if Client.debug?

      case response.code
      when 200
        return Record.new({:domain => domain}.merge(response["record"]))
      when 401
        raise RuntimeError, "Authentication failed"
      when 404
        raise RuntimeError, "Could not find record #{id} for domain #{domain_name}"
      else
        raise DNSimple::Error.new("#{domain_name}/#{id}", response["errors"])
      end
    end

    def self.all(domain_name, options={})
      domain = Domain.find(domain_name)
      options.merge!({:basic_auth => Client.credentials})
      response = self.get("/domains/#{domain.id}/records.json", options)

      pp response if Client.debug?

      case response.code
      when 200
        response.map { |r| Record.new({:domain => domain}.merge(r["record"])) }
      when 401
        raise RuntimeError, "Authentication failed"
      else
        raise RuntimeError, "Error: #{response.code}"
      end
    end

  end
end
