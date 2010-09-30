require 'yaml'

module DNSimple
  
  class CommandNotFound < RuntimeError
  end

  class CLI
    def initialize
      credentials = load_credentials
      Client.username = credentials['username']
      Client.password = credentials['password']
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
        'info' => DNSimple::Commands::DescribeUser,

        'create' => DNSimple::Commands::CreateDomain,
        'register' => DNSimple::Commands::RegisterDomain,
        'transfer' => DNSimple::Commands::TransferDomain,
        'describe' => DNSimple::Commands::DescribeDomain,
        'list' => DNSimple::Commands::ListDomains,
        'delete' => DNSimple::Commands::DeleteDomain,
        'clear' => DNSimple::Commands::ClearDomain,
        'apply' => DNSimple::Commands::ApplyTemplate,
        
        'record:create' => DNSimple::Commands::CreateRecord,
        'record:list' => DNSimple::Commands::ListRecords,
        'record:delete' => DNSimple::Commands::DeleteRecord,

        'template:create' => DNSimple::Commands::CreateTemplate,
        'template:list' => DNSimple::Commands::ListTemplates,
        'template:records' => DNSimple::Commands::ListTemplateRecords,
      }
    end

    private
    def load_credentials
      YAML.load(File.new(File.expand_path('~/.dnsimple')))
    end
  end
end

require 'dnsimple/commands/describe_user'
require 'dnsimple/commands/create_domain'
require 'dnsimple/commands/register_domain'
require 'dnsimple/commands/transfer_domain'
require 'dnsimple/commands/describe_domain'
require 'dnsimple/commands/list_domains'
require 'dnsimple/commands/delete_domain'
require 'dnsimple/commands/clear_domain'
require 'dnsimple/commands/apply_template'

require 'dnsimple/commands/create_record'
require 'dnsimple/commands/list_records'
require 'dnsimple/commands/delete_record'

require 'dnsimple/commands/create_template'
require 'dnsimple/commands/list_templates'
require 'dnsimple/commands/list_template_records'
