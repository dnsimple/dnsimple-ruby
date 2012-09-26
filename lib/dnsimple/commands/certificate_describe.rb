module DNSimple
  module Commands
    class CertificateDescribe
      def execute(args, options = {})
        domain_name = args.shift
        certificate_id = args.shift
        domain = Domain.find(domain_name)
        certificate = Certificate.find(domain, certificate_id)
        puts "Certificate: #{certificate.fqdn}"
        puts "\tID: #{certificate.id}"
        puts "\tStatus: #{certificate.certificate_status}"
        puts "\tCreated: #{certificate.created_at}"
        puts "\tOrder Date: #{certificate.order_date}"
        puts "\tExpires: #{certificate.expiration_date}"

        if certificate.approver_email =~ /\S+/
          puts "\tApprover email: #{certificate.approver_email}"
        else
          puts "\tAvailable approver emails:"
          certificate.available_approver_emails.split(",").each do |email|
            puts "\t\t#{email}"
          end
        end
        
        puts
        puts "#{certificate.csr}"
        puts
        puts "#{certificate.private_key}"
        puts 
        puts "#{certificate.ssl_certificate}"
      end
    end
  end
end
