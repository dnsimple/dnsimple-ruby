module DNSimple
  module Commands
    class DomainList
      def execute(args, options = {})
        domains = Domain.all
        puts "Found #{domains.length} domains:"
        domains.each do |domain|
          puts "\t#{domain.name}"
        end
      end
    end
  end
end
