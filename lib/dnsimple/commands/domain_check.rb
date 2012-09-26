module DNSimple
  module Commands
    class DomainCheck
      def execute(args, options = {})
        name = args.shift
        response = Domain.check(name)
        puts "Check domain result for #{name}: #{response}"
      end
    end
  end
end
