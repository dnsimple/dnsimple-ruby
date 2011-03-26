module DNSimple
  module Commands
    class CreateContact
      # Execute the contact:create command.
      # 
      # Args expected to be:
      # [name:value name:value ...]
      def execute(args, options={})
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
