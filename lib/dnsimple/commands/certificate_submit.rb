module DNSimple
  module Commands
    class CertificateSubmit
      def execute(args, options = {})
        domain_name = args.shift
        certificate_id = args.shift
        approver_email = args.shift
        
        domain = DNSimple::Domain.find(domain_name)
        certificate = DNSimple::Certificate.find(domain, certificate_id)
        certificate.submit(approver_email)

        puts "Certificate submitted, authorization by email required"
      end
    end
  end
end
