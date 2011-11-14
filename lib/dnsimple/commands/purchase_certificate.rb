require 'dnsimple/command'

module DNSimple
  module Commands
    class PurchaseCertificate < Command
      def execute(args, options={})
        domain_name = args.shift
        name = args.shift
        contact_id = args.shift

        domain = Domain.find(domain_name)
        contact = Contact.find(contact_id)
        
        certificate = Certificate.purchase(domain, name, contact)
        say "Purchased certificate for #{certificate.fqdn}"
      end
    end
  end
end
