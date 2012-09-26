module DNSimple
  module Commands
    class ServiceList
      def execute(args, options = {})
        services = Service.all
        puts "Found #{services.length} services:"
        services.each do |service|
          puts "\t#{service.name} (short: #{service.short_name}, id: #{service.id})"
          puts "\t\t#{service.description}"
        end
      end
    end
  end
end
