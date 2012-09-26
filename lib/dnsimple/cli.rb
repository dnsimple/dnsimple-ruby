module DNSimple

  class CommandNotFound < RuntimeError
  end

  class CLI

    def execute(command_name, args, options={})
      DNSimple::Client.load_credentials_if_necessary
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
        'info' => DNSimple::Commands::Me,

        'list' => DNSimple::Commands::DomainList,
        'describe' => DNSimple::Commands::DomainDescribe,
        'check' => DNSimple::Commands::DomainCheck,
        'create' => DNSimple::Commands::DomainCreate,
        'register' => DNSimple::Commands::DomainRegister,
        'transfer' => DNSimple::Commands::DomainTransfer,
        'delete' => DNSimple::Commands::DomainDelete,
        'clear' => DNSimple::Commands::DomainClear,
        'apply' => DNSimple::Commands::DomainApplyTemplate,

        'record:describe' => DNSimple::Commands::RecordDescribe,
        'record:create' => DNSimple::Commands::RecordCreate,
        'record:list' => DNSimple::Commands::RecordList,
        'record:update' => DNSimple::Commands::RecordUpdate,
        'record:delete' => DNSimple::Commands::RecordDelete,

        'template:create' => DNSimple::Commands::TemplateCreate,
        'template:list' => DNSimple::Commands::TemplateList,
        'template:delete' => DNSimple::Commands::TemplateDelete,

        'template:list_records' => DNSimple::Commands::TemplateRecordList,
        'template:add_record' => DNSimple::Commands::TemplateRecordCreate,
        'template:delete_record' => DNSimple::Commands::TemplateRecordDelete,

        'contact:create' => DNSimple::Commands::ContactCreate,
        'contact:list' => DNSimple::Commands::ContactList,
        'contact:describe' => DNSimple::Commands::ContactDescribe,
        'contact:update' => DNSimple::Commands::ContactUpdate,
        'contact:delete' => DNSimple::Commands::ContactDelete,

        'extended-attributes:list' => DNSimple::Commands::ExtendedAttributeList,

        'service:list' => DNSimple::Commands::ServiceList,
        'service:describe' => DNSimple::Commands::ServiceDescribe,

        'service:applied' => DNSimple::Commands::ServiceListApplied,
        'service:available' => DNSimple::Commands::ServiceListAvailable,
        'service:add' => DNSimple::Commands::ServiceAdd,
        'service:remove' => DNSimple::Commands::ServiceRemove,

        'certificate:list' => DNSimple::Commands::CertificateList,
        'certificate:describe' => DNSimple::Commands::CertificateDescribe,
        'certificate:purchase' => DNSimple::Commands::CertificatePurchase,
        'certificate:submit' => DNSimple::Commands::CertificateSubmit,
      }
    end
  end
end

require 'dnsimple/commands/me'

require 'dnsimple/commands/domain_list'
require 'dnsimple/commands/domain_describe'
require 'dnsimple/commands/domain_check'
require 'dnsimple/commands/domain_create'
require 'dnsimple/commands/domain_register'
require 'dnsimple/commands/domain_transfer'
require 'dnsimple/commands/domain_delete'
require 'dnsimple/commands/domain_clear'
require 'dnsimple/commands/domain_apply_template'

require 'dnsimple/commands/record_list'
require 'dnsimple/commands/record_describe'
require 'dnsimple/commands/record_create'
require 'dnsimple/commands/record_update'
require 'dnsimple/commands/record_delete'

require 'dnsimple/commands/template_list'
require 'dnsimple/commands/template_create'
require 'dnsimple/commands/template_delete'
require 'dnsimple/commands/template_record_list'
require 'dnsimple/commands/template_record_create'
require 'dnsimple/commands/template_record_delete'

require 'dnsimple/commands/contact_list'
require 'dnsimple/commands/contact_describe'
require 'dnsimple/commands/contact_create'
require 'dnsimple/commands/contact_update'
require 'dnsimple/commands/contact_delete'

require 'dnsimple/commands/extended_attribute_list'

require 'dnsimple/commands/service_list'
require 'dnsimple/commands/service_describe'

require 'dnsimple/commands/service_list_available'
require 'dnsimple/commands/service_list_applied'
require 'dnsimple/commands/service_add'
require 'dnsimple/commands/service_remove'

require 'dnsimple/commands/certificate_list'
require 'dnsimple/commands/certificate_describe'
require 'dnsimple/commands/certificate_purchase'
require 'dnsimple/commands/certificate_submit'
