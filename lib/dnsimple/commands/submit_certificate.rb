require 'dnsimple/command'

module DNSimple
  module Commands
    class SubmitCertificate < Command
      def execute(args, options={})
        domain_name = args.shift
        certificate_id = args.shift
        approver_email = args.shift
        
        domain = DNSimple::Domain.find(domain_name)
        certificate = DNSimple::Certificate.find(domain, certificate_id)
        certificate.submit(approver_email)

        say "Certificate submitted, authorization by email required"
      end
    end
  end
end
