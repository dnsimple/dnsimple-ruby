module DNSimple
  module Commands
    class DomainRegister
      def execute(args, options = {})
        name = args.shift
        registrant = nil

        registrant_id_or_attribute = args.shift
        if registrant_id_or_attribute
          if registrant_id_or_attribute =~ /^\d+$/
            registrant = {:id => registrant_id_or_attribute}
          else
            args.unshift(registrant_id_or_attribute)
          end
        end

        extended_attributes = {}
        args.each do |arg|
          n, v = arg.split(":")
          extended_attributes[n] = v
        end

        domain = Domain.register(name, registrant, extended_attributes)
        puts "Registered #{domain.name}"

        if template = options.delete(:template)
          domain.apply(template)
          puts "Applied template #{template} to #{domain.name}"
        end
      end
    end
  end
end
