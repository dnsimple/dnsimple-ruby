module DNSimple
  module Commands
    class DescribeContact
      def execute(args, options={})
        id = args.shift
        contact = Contact.find(id)
        puts "Contact: #{contact.name}:"
        puts "\tID: #{contact.id}"
        puts "\tFirst Name: #{contact.first_name}"
        puts "\tLast Name: #{contact.last_name}"
        puts "\tOrganization Name: #{contact.organization_name}" unless contact.organization_name.blank?
        puts "\tJob Title: #{contact.job_title}" unless contact.job_title.blank?
        puts "\tAddress 1: #{contact.address1}"
        puts "\tAddress 2: #{contact.address2}"
        puts "\tCity: #{contact.city}"
        puts "\tState or Province: #{contact.state_province}"
        puts "\tPostal Code: #{contact.postal_code}"
        puts "\tCountry: #{contact.country}"
        puts "\tEmail: #{contact.email_address}"
        puts "\tPhone: #{contact.phone}"
        puts "\tPhone Ext: #{contact.phone_ext}" unless contact.phone_ext.blank?
      end
    end
  end
end
