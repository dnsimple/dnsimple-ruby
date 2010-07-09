module DNSimple
  module Commands
    class DescribeDomain
      def execute(args, options={})
        name = args.shift
        domain = Domain.find(name)
        puts "Domain #{domain.name}:"
        puts "\tID: #{domain.id}"
        puts "\tCreated: #{domain.created_at}"
      end
    end
  end
end
