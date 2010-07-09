require 'yaml'

module DNSimple
  
  class CommandNotFound < RuntimeError
  end

  class CLI
    def initialize
      credentials = load_credentials
      Client.credentials(credentials['username'], credentials['password'])
    end

    def execute(command_name, args, options={})
      command = commands[command_name]
      if command
        begin
          command.new.execute(args, options)
        rescue DNSimple::Error => e
          puts "An error occurred: #{e.message}"
        rescue RuntimeError => e
          puts "An error occurred: #{e.message}"
        end
      else
        raise CommandNotFound, "Unknown command: #{command_name}"
      end
    end

    def commands
      {
        'create' => DNSimple::Commands::CreateDomain,
        'delete' => DNSimple::Commands::DeleteDomain,
        'describe' => DNSimple::Commands::DescribeDomain,
        'list' => DNSimple::Commands::ListDomains,
        
        'record:create' => DNSimple::Commands::CreateRecord
      }
    end

    private
    def load_credentials
      YAML.load(File.new(File.expand_path('~/.dnsimple')))
    end
  end
end

require 'dnsimple/commands/create_domain'
require 'dnsimple/commands/delete_domain'
require 'dnsimple/commands/describe_domain'
require 'dnsimple/commands/list_domains'
require 'dnsimple/commands/create_record'
