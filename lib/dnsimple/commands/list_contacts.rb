module DNSimple
  module Commands
    class ListContacts
      def execute(args, options = {})
        contacts = Contact.all
        puts "Found #{contacts.length} contacts:"
        contacts.each do |contact|
          puts "\t#{contact.name} (id:#{contact.id})"
        end
      end
    end
  end
end
