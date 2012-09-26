module DNSimple
  module Commands
    class DomainDelete
      def execute(args, options = {})
        name_or_id = args.shift

        domain = Domain.find(name_or_id)
        domain.delete

        puts "Deleted #{domain.name}"
      end
    end
  end
end
