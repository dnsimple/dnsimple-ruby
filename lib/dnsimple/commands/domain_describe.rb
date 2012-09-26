module DNSimple
  module Commands
    class DomainDescribe
      def execute(args, options = {})
        name = args.shift
        domain = Domain.find(name)
        puts "Domain #{domain.name}:"
        puts "\tID: #{domain.id}"
        puts "\tCreated: #{domain.created_at}"
        puts "\tName Server Status: #{domain.name_server_status}"
      end
    end
  end
end
