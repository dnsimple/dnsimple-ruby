module DNSimple
  module Commands
    class ServiceRemove
      def execute(args, options = {})
        domain_name = args.shift
        domain = Domain.find(domain_name)
        short_name = args.shift
        service = Service.find(short_name)
        domain.remove_service(service.id)
        puts "Removed #{service.name} from #{domain_name}"
      end
    end
  end
end
