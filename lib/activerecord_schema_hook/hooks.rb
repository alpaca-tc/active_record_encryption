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

      def run_hooks(klass)
        registry.each_value do |block|
          block.call(klass)
        end
      end

      private

      def registry
        @registry ||= {}
      end
    end
  end
end
