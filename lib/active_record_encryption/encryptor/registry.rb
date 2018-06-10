# frozen_string_literal: true

module ActiveRecordEncryption
  module Encryptor
    class Registry
      def initialize
        @registrations = []
      end

      def register(encryptor_name, klass = nil, **options, &block)
        block ||= proc { |_, *args| klass.new(*args) }
        registrations << Registration.new(encryptor_name, block, **options)
      end

      def lookup(symbol, *args)
        registration = find_registration(symbol, *args)

        if registration
          registration.call(self, symbol, *args)
        else
          raise ArgumentError, "Unknown encryptor #{symbol.inspect}"
        end
      end

      private

      attr_reader :registrations

      def find_registration(symbol, *args)
        registrations.find { |registration| registration.matches?(symbol, *args) }
      end
    end

    class Registration
      def initialize(name, block, **)
        @name = name
        @block = block
      end

      def call(_registry, *args, **kwargs)
        if kwargs.any? # https://bugs.ruby-lang.org/issues/10856
          block.call(*args, **kwargs)
        else
          block.call(*args)
        end
      end

      def matches?(encryptor_name, *_args, **_kwargs)
        encryptor_name == name
      end

      private

      attr_reader :name, :block
    end
  end
end
