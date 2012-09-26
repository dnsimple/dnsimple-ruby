module DNSimple
  module Commands
    class ServiceListApplied
      def execute(args, options = {})
        domain_name = args.shift
        domain = Domain.find(domain_name)
        services = domain.applied_services
        puts "Found #{services.length} applied services for #{domain_name}"
        services.each do |service|
          puts "\t#{service.name} (short: #{service.short_name}, id: #{service.id})"
          puts "\t\t#{service.description}"
        end
      end
    end
  end
end
