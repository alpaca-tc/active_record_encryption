# frozen_string_literal: true

module ActiverecordSchemaHook
  module Hooks
    class << self
      def register(name, &block)
        registry[name] = block
      end

      def deregister(name)
        registry.delete(name)
      end

      private

      def registry
        @registry ||= {}
      end
    end
  end
end
