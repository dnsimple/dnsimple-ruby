# frozen_string_literal: true

module Dnsimple
  module Struct

    class Service < Base

      class Setting < Base
        # @return [String] The setting name.
        attr_accessor :name

        # @return [String] The setting label.
        attr_accessor :label

        # @return [String] A suffix to be appended to the setting value.
        attr_accessor :append

        # @return [String] The setting description.
        attr_accessor :description

        # @return [String] An example of the setting value.
        attr_accessor :example

        # @return [Boolean] Whether the setting requires a password.
        attr_accessor :password
      end

      # @return [Integer] The service ID in DNSimple.
      attr_accessor :id

      # @return [String] The service name.
      attr_accessor :name

      # @return [String] A string ID for the service.
      attr_accessor :sid

      # @return [String] The service description.
      attr_accessor :description

      # @return [String] The service setup description.
      attr_accessor :setup_description

      # @return [Boolean] Whether the service requires extra setup.
      attr_accessor :requires_setup

      # @return [String] The default subdomain where the service will be applied.
      attr_accessor :default_subdomain

      # @return [Array<Settings>] The array of settings to setup this service, if setup is required.
      attr_reader :settings

      def initialize(*)
        super
        @settings ||= []
      end

      def settings=(settings)
        @settings = settings.map do |setting|
          Setting.new(setting)
        end
      end

    end

  end
end
