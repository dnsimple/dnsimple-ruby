module DNSimple
  module Commands
    class DomainClear
      def execute(args, options = {})
        name = args.shift

        records = Record.all(name)
        records.each do |record|
          record.delete
        end

        puts "Deleted #{records.length} records from #{name}"
      end
    end
  end
end
