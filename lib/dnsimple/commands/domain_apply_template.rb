module DNSimple
  module Commands
    class DomainApplyTemplate
      def execute(args, options = {})
        domain_name = args.shift
        template_name = args.shift

        domain = Domain.find(domain_name)
        domain.apply(template_name)

        puts "Applied template #{template_name} to #{domain.name}"
      end
    end
  end
end
