module DNSimple
  module Commands
    class RecordDescribe
      def execute(args, options = {})
        name = args.shift
        id = args.shift
        record = Record.find(name, id)
        puts "Record #{record.fqdn}:"
        puts "\tID: #{record.id}"
        puts "\tTTL: #{record.ttl}"
        puts "\tPrio: #{record.prio}"
        puts "\tContent: #{record.content}"
      end
    end
  end
end
