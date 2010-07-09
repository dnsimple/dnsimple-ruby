module DNSimple
  module Commands
    class ListRecords
      def execute(args, options={})
        domain_name = args.shift
        records = Record.all(domain_name)
        puts "Found #{records.length} records for #{domain_name}"
        records.each do |record|
          puts "\t#{record.name}.#{record.domain.name} (#{record.record_type})-> #{record.content} (ttl:#{record.ttl},id:#{record.id})"
        end
      end
    end
  end
end
