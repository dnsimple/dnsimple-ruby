module DNSimple
  module Commands
    class TemplateRecordDelete
      def execute(args, options = {})
        short_name = args.shift
        id = args.shift

        template = Template.find(short_name)
        record = TemplateRecord.find(template.short_name, id)
        record.delete

        puts "Deleted #{record.id} from template #{short_name}"
      end
    end
  end
end
