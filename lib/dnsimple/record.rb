module DNSimple

  class Record < Base
    Aliases = {
      'priority'     => 'prio',
      'time-to-live' => 'ttl'
    }

    attr_accessor :id

    attr_accessor :domain

    attr_accessor :name

    attr_accessor :content

    attr_accessor :record_type

    attr_accessor :ttl

    attr_accessor :prio

    def fqdn
      [name, domain.name].delete_if { |v| v !~ DNSimple::BLANK_REGEX }.join(".")
    end

    def save(options={})
      record_hash = {}
      %w(name content ttl prio).each do |attribute|
        record_hash[DNSimple::Record.resolve(attribute)] = self.send(attribute)
      end

      options.merge!(:body => {:record => record_hash})

      response = DNSimple::Client.put("domains/#{domain.id}/records/#{id}", options)

      case response.code
      when 200
        self
      else
        raise RequestError.new("Error updating record", response)
      end
    end

    def delete(options={})
      DNSimple::Client.delete("domains/#{domain.id}/records/#{id}", options)
    end
    alias :destroy :delete

    def self.resolve(name)
      DNSimple::Record::Aliases[name] || name
    end

    def self.create(domain, name, record_type, content, options={})
      record_hash = {:name => name, :record_type => record_type, :content => content}
      record_hash[:ttl] = options.delete(:ttl) || 3600
      record_hash[:prio] = options.delete(:priority)
      record_hash[:prio] = options.delete(:prio) || ''

      options.merge!({:body => {:record => record_hash}})

      response = DNSimple::Client.post("domains/#{domain.name}/records", options)

      case response.code
      when 201
        new({:domain => domain}.merge(response["record"]))
      when 406
        raise RecordExists, "Record #{name}.#{domain.name} already exists"
      else
        raise RequestError.new("Error creating record", response)
      end
    end

    def self.find(domain, id, options={})
      response = DNSimple::Client.get("domains/#{domain.name}/records/#{id}", options)

      case response.code
      when 200
        new({:domain => domain}.merge(response["record"]))
      when 404
        raise RecordNotFound, "Could not find record #{id} for domain #{domain.name}"
      else
        raise RequestError.new("Error finding record", response)
      end
    end

    def self.all(domain, options={})
      response = DNSimple::Client.get("domains/#{domain.name}/records", options)

      case response.code
      when 200
        response.map { |r| new({:domain => domain}.merge(r["record"])) }
      else
        raise RequestError.new("Error listing records", response)
      end
    end

  end
end
