class DNSimple::Template < DNSimple::Base
  # The template ID in DNSimple
  attr_accessor :id

  # The template name
  attr_accessor :name

  # The template short name
  attr_accessor :short_name

  # The template description
  attr_accessor :description

  # Delete the template from DNSimple. WARNING: this cannot
  # be undone.
  def delete(options={})
    DNSimple::Client.delete "templates/#{id}", options
  end
  alias :destroy :delete

  def self.create(name, short_name, description=nil, options={})
    template_hash = {
      :name        => name,
      :short_name  => short_name,
      :description => description
    }

    options.merge!(:body => {:dns_template => template_hash})

    response = DNSimple::Client.post 'templates', options

    case response.code
    when 201
      return new(response["dns_template"])
    else
      raise DNSimple::Error.new(name, response["errors"])
    end
  end

  def self.find(id_or_short_name, options={})
    response = DNSimple::Client.get "templates/#{id_or_short_name}", options

    case response.code
    when 200
      return new(response["dns_template"])
    when 404
      raise RuntimeError, "Could not find template #{id_or_short_name}"
    else
      raise DNSimple::Error.new(id_or_short_name, response["errors"])
    end
  end

  def self.all(options={})
    response = DNSimple::Client.get 'templates', options

    case response.code
    when 200
      response.map { |r| new(r["dns_template"]) }
    else
      raise RuntimeError, "Error: #{response.code}"
    end
  end
end
