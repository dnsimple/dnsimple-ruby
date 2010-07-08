module DNSimple
  module Commands
    class CreateDomain
      def execute(args, options={})
        name = args.shift

        Domain.create(name) 

        puts "Created #{name}"
      end
    end
  end
end
