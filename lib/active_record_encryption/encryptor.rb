# frozen_string_literal: true

require 'active_record_encryption/encryptor/registry'
require 'active_record_encryption/encryptor/base'
require 'active_record_encryption/encryptor/raw'
require 'active_record_encryption/encryptor/active_support'
require 'active_record_encryption/encryptor/aes_128_ecb'
require 'active_record_encryption/encryptor/aes_256_cbc'

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

    register(:raw, ActiveRecordEncryption::Encryptor::Raw)
    register(:active_support, ActiveRecordEncryption::Encryptor::ActiveSupport)
    register(:aes_128_ecb, ActiveRecordEncryption::Encryptor::Aes128Ecb)
    register(:aes_256_cbc, ActiveRecordEncryption::Encryptor::Aes256Cbc)
  end
end
