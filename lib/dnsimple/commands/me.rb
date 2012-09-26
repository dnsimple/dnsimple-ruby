module DNSimple
  module Commands
    class Me
      def execute(args, options = {})
        puts "Connecting to #{Client.base_uri}"
        user = User.me
        puts "User details:"
        puts "\tID:#{user.id}"
        puts "\tCreated: #{user.created_at}"
        puts "\tEmail: #{user.email}"
        puts "\tSuccessful logins: #{user.login_count}"
        puts "\tFailed logins: #{user.failed_login_count}"
        puts "\tDomains in account: #{user.domain_count}"
        puts "\tDomains allowed: #{user.domain_limit}"
      end
    end
  end
end
