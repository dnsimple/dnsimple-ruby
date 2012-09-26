module DNSimple
  module Commands
    class TemplateDelete
      def execute(args, options = {})
        short_name = args.shift
        template = Template.find(short_name)
        template.delete

        puts "Deleted template #{short_name}"
      end
    end
  end
end
