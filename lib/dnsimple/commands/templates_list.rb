module DNSimple
  module Commands
    class TemplateList
      def execute(args, options = {})
        templates = Template.all
        puts "Found #{templates.length} templates:"
        templates.each do |template|
          puts "\t#{template.name} (short_name:#{template.short_name})" 
        end
      end
    end
  end
end
