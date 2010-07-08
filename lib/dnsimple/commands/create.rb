module DNSimple
  module Commands
    class Create
      def execute(args)
        name = args.shift
        options = args

        Domain.create(name) 
      end
    end
  end
end
