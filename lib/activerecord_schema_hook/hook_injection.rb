# frozen_string_literal: true

module ActiverecordSchemaHook
  module HookInjection
    extend ActiveSupport::Concern

    included do
      ActiverecordSchemaHook::Hooks.dependencies.push(self)
    end

    module ClassMethods
      private

      def load_schema!
        super

        ActiverecordSchemaHook::Hooks.run_hooks(self)

        # schema was reset by hook
        super
      end
    end
  end
end
