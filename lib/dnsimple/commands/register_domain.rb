module DNSimple
  module Commands
    class RegisterDomain
      def execute(args, options={})
        name = args.shift
        registrant = {:id => args.shift}
        domain = Domain.register(name, registrant)
        puts "Registered #{domain.name}"

        if template = options.delete(:template)
          domain.apply(template)
          puts "Applied template #{template} to #{domain.name}"
        end
      end
    end
  end
end
