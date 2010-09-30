module DNSimple
  module Commands
    class TransferDomain
      def execute(args, options={})
        name = args.shift
        registrant = {:id => args.shift}
        authinfo = args.shift unless args.empty?
        authinfo ||= ''

        transfer_order = TransferOrder.create(name, authinfo, registrant)
        puts "Transfer order issued for #{name}"
      end
    end
  end
end
