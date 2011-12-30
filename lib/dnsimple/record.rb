class DNSimple::Record < DNSimple::Base
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

    response = DNSimple::Client.put("domains/#{domain.id}/records/#{id}.json", options)

    case response.code
    when 200
      return self
    else
      raise DNSimple::Error, "Failed to update record: #{response.inspect}"
    end
  end

  def delete(options={})
    DNSimple::Client.delete "domains/#{domain.id}/records/#{id}", options
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

    response = DNSimple::Client.post "domains/#{domain.name}/records", options

    case response.code
    when 201
      return new({:domain => domain}.merge(response["record"]))
    when 406
      raise DNSimple::RecordExists.new("#{name}.#{domain.name}", response["errors"])
    else
      raise DNSimple::Error, "Failed to create #{name}.#{domain.name}: #{response["errors"]}"
    end
  end

  def self.find(domain, id, options={})
    response = DNSimple::Client.get("domains/#{domain.name}/records/#{id}", options)

    case response.code
    when 200
      return new({:domain => domain}.merge(response["record"]))
    when 404
      raise DNSimple::RecordNotFound, "Could not find record #{id} for domain #{domain.name}"
    else
      raise DNSimple::Error, "Failed to find domain #{domain.name}/#{id}: #{response["errors"]}"
    end
  end

  def self.all(domain, options={})
    response = DNSimple::Client.get("domains/#{domain.name}/records", options)

    case response.code
    when 200
      response.map { |r| new({:domain => domain}.merge(r["record"])) }
    else
      raise DNSimple::Error, "Error listing domains: #{response.code}"
    end
  end
end
