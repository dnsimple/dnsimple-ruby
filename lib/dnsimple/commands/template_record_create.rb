module DNSimple
  module Commands
    class TemplateRecordCreate
      def execute(args, options = {})
        short_name = args.shift
        record_name = args.shift
        record_type = args.shift
        content = args.shift
        ttl = args.shift

        template = Template.find(short_name)
        record = TemplateRecord.create(template.short_name, record_name, record_type, content, :ttl => ttl, :prio => options[:prio])
        
        puts "Created #{record.record_type} with content '#{record.content}' record for template #{template.name}"
      end
    end
  end
end
