module DNSimple
  module Commands
    class RecordCreate
      def execute(args, options = {})
        name = args.shift
        record_name = args.shift
        record_type = args.shift
        content = args.shift
        ttl = args.shift

        domain = Domain.find(name)
        record = Record.create(domain, record_name, record_type, content, :ttl => ttl, :prio => options[:prio])

        puts "Created #{record.record_type} record for #{domain.name} (id:#{record.id})"
      end
    end
  end
end
