module DNSimple
  module Commands
    class PurchaseCertificate
      def execute(args, options={})
        domain_name = args.shift
        name = args.empty? ? '' : args.shift
        
        certificate = Certificate.purchase(domain_name, name)
        puts "Purchased certificate for #{certificate.fqdn}"
      end
    end
  end
end
