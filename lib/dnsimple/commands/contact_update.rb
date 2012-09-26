module DNSimple
  module Commands
    class ContactUpdate
      # Execute the contact:update command.
      #
      # Args expected:
      # id [name:value name:value ...]
      def execute(args, options = {})
        attributes = {}
        id = args.shift
        args.each do |arg|
          name, value = arg.split(":")
          attributes[Contact.resolve(name)] = value
        end 

        contact = Contact.find(id)
        attributes.each do |name, value|
          contact.send("#{name}=", value)
        end
        contact.save
        puts "Updated contact #{contact.name} (id: #{contact.id})"
      end
    end
  end
end
