module Dnsimple
  module Options

    class Base
      def initialize(options)
        @options = (options || {}).dup
      end

      def to_h
        @options
      end
    end

    class ListOptions < Base
      def initialize(options)
        super
        @options[:query] ||= {} if @options.any?
        @sort              = @options.delete(:sort)
        @options[:query].merge!(sort: @sort) unless @sort.nil?
      end
    end

  end
end
