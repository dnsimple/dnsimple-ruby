module DNSimple
  module Commands
    class ExtendedAttributeList
      def execute(args, options = {})
        tld = args.shift
        extended_attributes = ExtendedAttribute.find(tld)
        puts "Extended attributes: "
        extended_attributes.each do |extended_attribute|
          o = "  #{extended_attribute.name}"
          o << " (required)" if extended_attribute.required
          o << " : #{extended_attribute.description}\n"
          unless extended_attribute.options.empty?
            o << "    Options:\n"
            extended_attribute.options.each do |option|
              o << "      #{option.title}: #{option.value}"
              o << " (#{option.description})" if option.description
              o << "\n"
            end
          end
          puts o
        end
      end
    end
  end
end
