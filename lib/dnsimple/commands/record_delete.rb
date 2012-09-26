module DNSimple
  module Commands
    class RecordDelete
      def execute(args, options = {})
        domain_name = args.shift
        id = args.shift

        domain = Domain.find(domain_name)
        record = Record.find(domain, id)
        record.delete

        puts "Deleted #{record.id} from #{domain.name}"
      end
    end
  end
end
