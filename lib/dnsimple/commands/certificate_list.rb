module DNSimple
  module Commands
    class CertificateList
      def execute(args, options = {})
        domain_name = args.shift
        domain = DNSimple::Domain.find(domain_name)
        certificates = DNSimple::Certificate.all(domain)
        puts "Found #{certificates.length} certificate for #{domain_name}"
        certificates.each do |certificate|
          puts "\t#{certificate.fqdn} (id: #{certificate.id}, status: #{certificate.certificate_status})" 
        end
      end
    end
  end
end
