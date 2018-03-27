# frozen_string_literal: true

module ActiverecordSchemaHook
  module Hooks
    class << self
      def register(name, klass, matcher: nil)
        registry.register(name, klass, matcher)
      end

      def deregister(name)
        registry.deregister(name)
      end

      private

      def registry
        @registry ||= Registry.new
      end
    end
  end
end
