module DNSimple
  module Commands
    class CertificatePurchase
      def execute(args, options = {})
        domain_name = args.shift
        name = args.shift
        contact_id = args.shift

        domain = Domain.find(domain_name)
        contact = Contact.find(contact_id)
        
        certificate = Certificate.purchase(domain, name, contact)
        puts "Purchased certificate for #{certificate.fqdn}"
      end
    end
  end
end
