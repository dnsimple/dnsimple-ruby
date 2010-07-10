module DNSimple
  module Commands
    class CreateDomain
      def execute(args, options={})
        name = args.shift
        domain = Domain.create(name) 
        puts "Created #{domain.name}"
      end
    end
  end
end
