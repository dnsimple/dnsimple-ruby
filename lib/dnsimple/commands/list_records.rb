module DNSimple
  module Commands
    class ListRecords
      def execute(args, options={})
        domain_name = args.shift
        records = Record.all(domain_name)
        puts "Found #{records.length} records for #{domain_name}"
        records.each do |record|
          extra = ["ttl:#{record.ttl}", "id:#{record.id}"]
          extra << "prio:#{record.prio}" if record.record_type == "MX"
          extra = "(#{extra.join(', ')})"
          puts "\t#{record.name}.#{record.domain.name} (#{record.record_type})-> #{record.content} #{extra}"
        end
      end
    end
  end
end
