require 'dnsimple/command'

module DNSimple
  module Commands
    class PurchaseCertificate < Command
      def execute(args, options={})
        domain_name = args.shift
        name = args.empty? ? '' : args.shift
        
        certificate = Certificate.purchase(domain_name, name)
        say "Purchased certificate for #{certificate.fqdn}"
      end
    end
  end
end
