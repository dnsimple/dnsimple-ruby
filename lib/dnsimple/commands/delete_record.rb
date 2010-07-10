module DNSimple
  module Commands
    class DeleteRecord
      def execute(args, options={})
        domain_name = args.shift
        id = args.shift

        domain = Domain.find(domain_name)
        record = Record.find(domain.name, id)
        record.delete

        puts "Deleted #{record.id} from #{domain.name}"
      end
    end
  end
end
