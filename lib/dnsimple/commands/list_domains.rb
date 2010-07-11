module DNSimple
  module Commands
    class ListDomains
      def execute(args, options={})
        puts "Base URI: #{Domain.base_uri}"
        domains = Domain.all
        puts "Found #{domains.length} domains:"
        domains.each do |domain|
          puts "\t#{domain.name}"
        end
      end
    end
  end
end
