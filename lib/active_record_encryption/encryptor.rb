# frozen_string_literal: true

require 'active_record_encryption/encryptor/registry'
require 'active_record_encryption/encryptor/base'

module ActiveRecordEncryption
  module Encryptor
    @registry = Registry.new

    class << self
      attr_reader :registry

      # Add a new type to the registry, allowing it to be gotten through ActiveRecordEncryption::Type#lookup
      def register(type_name, klass = nil, **options, &block)
        registry.register(type_name, klass, **options, &block)
      end

      def lookup(*args, **kwargs)
        registry.lookup(*args, **kwargs)
      end
    end
  end
end
