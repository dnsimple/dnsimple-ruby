module DNSimple
  module Commands
    class DomainCreate
      def execute(args, options = {})
        name = args.shift
        domain = Domain.create(name) 
        puts "Created #{domain.name}"

        if template = options.delete(:template)
          domain.apply(template)
          puts "Applied template #{template} to #{domain.name}"
        end
      end
    end
  end
end
