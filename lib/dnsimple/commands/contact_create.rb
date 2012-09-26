module DNSimple
  module Commands

    # Command to create a contact.
    #
    #   contact:create [ name:value name:value ... ]
    #
    class ContactCreate
      def execute(args, options = {})
        attributes = {}
        attributes['state_province_choice'] = 'S'
        args.each do |arg|
          name, value = arg.split(":")
          attributes[Contact.resolve(name)] = value
        end

        contact = Contact.create(attributes, options)
        puts "Created contact #{contact.name} (id: #{contact.id})"
      end
    end

  end
end
