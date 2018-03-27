# frozen_string_literal: true

require 'set'

module ActiverecordSchemaHook
  module Hooks
    class Registry
      def initialize
        @registrations = {}
      end

      def register(name, klass, matcher)
        block ||= proc { |_, *args| klass.new(*args) }
        registrations[name] = [matcher, Registration.new(name, block)]
      end

      def deregister(name)
        registrations.delete(name)
      end

      private

      attr_reader :registrations

      def find_registration(symbol, *args)
        registrations.find { |r| r.matches?(symbol, *args) }
      end
    end

    class Registration
      def initialize(name, block)
        @name = name
        @block = block
      end

      def call(*args, **kwargs)
        if kwargs.any? # https://bugs.ruby-lang.org/issues/10856
          block.call(*args, **kwargs)
        else
          block.call(*args)
        end
      end

      def matches?(*_args, **_kwargs)
        type_name == name
      end

      private

      attr_reader :name, :block
    end
  end
end
