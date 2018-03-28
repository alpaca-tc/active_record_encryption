# frozen_string_literal: true

module ActiverecordSchemaHook
  module Hooks
    mattr_accessor :dependencies, default: []

    class << self
      def register(name, &block)
        registry[name] = block
        reload_schema_from_cache
      end

      def deregister(name)
        registry.delete(name)
        reload_schema_from_cache
      end

      def run_hooks(klass)
        registry.each_value do |block|
          block.call(klass)
        end
      end

      private

      def reload_schema_from_cache
        ActiverecordSchemaHook::Hooks.dependencies.each(&:reset_column_information)
      end

      def registry
        @registry ||= {}
      end
    end
  end
end
