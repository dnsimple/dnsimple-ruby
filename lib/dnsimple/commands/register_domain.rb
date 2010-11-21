module DNSimple
  module Commands
    class RegisterDomain
      def execute(args, options={})
        name = args.shift
        registrant = {:id => args.shift}

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
