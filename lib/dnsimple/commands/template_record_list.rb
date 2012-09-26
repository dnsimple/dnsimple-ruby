module DNSimple
  module Commands
    class TemplateRecordList
      def execute(args, options = {})
        short_name = args.shift
        template_records = TemplateRecord.all(short_name)
        puts "Found #{template_records.length} records for #{short_name}"
        template_records.each do |record|
          extra = ["ttl:#{record.ttl}", "id:#{record.id}"]
          extra << "prio:#{record.prio}" if record.record_type == "MX"
          extra = "(#{extra.join(', ')})"
          puts "\t#{record.name} (#{record.record_type})-> #{record.content} #{extra}"
        end
      end
    end
  end
end
