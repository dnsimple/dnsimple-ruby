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
        _prepare_query
        _prepare_sort
        _prepare_filter
      end

      private

      def _prepare_query
        @options[:query] ||= {} if @options.any?
      end

      def _prepare_sort
        @sort = @options.delete(:sort)
        _merge(sort: @sort) unless @sort.nil?
      end

      def _prepare_filter
        @filter = @options.delete(:filter)
        _merge(@filter) unless @filter.nil?
      end

      def _merge(hash)
        @options[:query].merge!(hash)
      end
    end

  end
end
