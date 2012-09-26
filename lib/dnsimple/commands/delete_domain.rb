module DNSimple
  module Commands
    class DeleteDomain
      def execute(args, options = {})
        name_or_id = args.shift

        domain = Domain.find(name_or_id)
        domain.delete

        puts "Deleted #{domain.name}"
      end
    end
  end
end
