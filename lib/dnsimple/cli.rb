require 'yaml'

module DNSimple
  
  class CommandNotFound < RuntimeError
  end

  class CLI
    def initialize
      credentials = load_credentials
      Client.credentials(credentials['username'], credentials['password'])
    end

    def execute(command_name, args)
      command = commands[command_name]
      if command
        command.new.execute(args)
      else
        raise CommandNotFound, "Unknown command: #{command_name}"
      end
    end

    def commands
      {
        'create' => DNSimple::Commands::Create
      }
    end

    private
    def load_credentials
      YAML.load(File.new(File.expand_path('~/.dnsimple')))
    end
  end
end

require 'dnsimple/commands/create'
