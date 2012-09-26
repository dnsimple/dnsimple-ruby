module DNSimple
  module Commands
    class DomainTransfer
      def execute(args, options = {})
        name = args.shift
        registrant = {:id => args.shift}
        authinfo = args.shift unless args.empty?
        authinfo ||= ''

        extended_attributes = {}
        args.each do |arg|
          n, v = arg.split(":")
          extended_attributes[n] = v
        end

        transfer_order = TransferOrder.create(name, authinfo, registrant, extended_attributes)
        puts "Transfer order issued for #{name}"
      end
    end
  end
end
