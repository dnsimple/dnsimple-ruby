module DNSimple
  module Commands
    class CreateContact
      # Execute the contact:create command.
      # 
      # Args expected to be:
      # first_name last_name [name:value name:value ...]
      def execute(args, options={})
        attributes = {}
        attributes['first_name'] = args.shift
        attributes['last_name'] = args.shift
        attributes['state_province_choice'] = 'S'
        args.each do |arg|
          name, value = arg.split(":")
          attributes[resolve(name)] = value
        end

        contact = Contact.create(attributes, options)
        puts "Created #{contact.name} (id: #{contact.id})"
      end

      private
      def resolve(name)
        aliases = {
          'state' => 'state_province',
          'province' => 'state_province',
          'email' => 'email_address',
        }
        aliases[name] || name
      end
    end
  end
end
