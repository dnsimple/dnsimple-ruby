module DNSimple
  class Template < Base

    attr_accessor :id
    attr_accessor :name
    attr_accessor :short_name
    attr_accessor :description


    def self.create(name, short_name, description=nil, options={})
      template_hash = {
        :name        => name,
        :short_name  => short_name,
        :description => description
      }

      options.merge!(:body => {:dns_template => template_hash})

      response = DNSimple::Client.post("templates", options)

      case response.code
      when 201
        new(response["dns_template"])
      else
        raise RequestError.new("Error creating template", response)
      end
    end

    def self.find(id_or_short_name, options={})
      id = id_or_short_name
      response = DNSimple::Client.get("templates/#{id}", options)

      case response.code
      when 200
        new(response["dns_template"])
      when 404
        raise RecordNotFound, "Could not find template #{id}"
      else
        raise RequestError.new("Error finding template", response)
      end
    end

    def self.all(options={})
      response = DNSimple::Client.get("templates", options)

      case response.code
      when 200
        response.map { |r| new(r["dns_template"]) }
      else
        raise RequestError.new("Error listing templates", response)
      end
    end


    # Delete the template from DNSimple.
    # WARNING: this cannot be undone.
    def delete(options={})
      DNSimple::Client.delete("templates/#{id}", options)
    end
    alias :destroy :delete

  end
end
