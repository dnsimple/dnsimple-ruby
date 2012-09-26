module DNSimple
  module Commands
    class TemplateCreate
      def execute(args, options = {})
        name = args.shift
        short_name = args.shift
        description = args.shift unless args.empty?

        template = Template.create(name, short_name, description)
        puts "Created #{template.name} (short_name:#{template.short_name})"
      end
    end
  end
end
