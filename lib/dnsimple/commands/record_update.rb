module DNSimple
  module Commands
    class RecordUpdate
      def execute(args, options = {})
        attributes = {}
        domain_name = args.shift
        id = args.shift
        args.each do |arg|
          name, value = arg.split(":")
          attributes[Record.resolve(name)] = value
        end

        domain = Domain.find(domain_name)
        record = Record.find(domain, id)
        attributes.each do |name, value|
          record.send("#{name}=", value)
        end
        record.save
        puts "Updated record #{record.fqdn} (id: #{record.id})"
      end
    end
  end
end
