module DNSimple
  module Commands
    class ServiceDescribe
      def execute(args, options = {})
        short_name = args.shift
        service = Service.find(short_name)
        puts "\t#{service.name} (short: #{service.short_name}, id: #{service.id})"
        puts "\t\t#{service.description}"
      end
    end
  end
end
