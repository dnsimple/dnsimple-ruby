require 'dnsimple/command'

module DNSimple
  module Commands
    class ListRecords < Command
      def execute(args, options={})
        domain_name = args.shift

        records = Record.all(DNSimple::Domain.new(:name => domain_name))

        say "Found #{records.length} records for #{domain_name}"
        records.each do |record|
          extra = ["ttl:#{record.ttl}", "id:#{record.id}"]
          extra << "prio:#{record.prio}" if record.record_type == "MX"
          extra = "(#{extra.join(', ')})"
          say "\t#{record.name}.#{record.domain.name} (#{record.record_type})-> #{record.content} #{extra}"
        end
      end
    end
  end
end
