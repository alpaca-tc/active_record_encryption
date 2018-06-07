# frozen_string_literal: true

module ActiveRecordEncryption
  module Encryptor
    class ActiveSupport < Raw
      def initialize(key:, salt:)
        key_generator = ::ActiveSupport::KeyGenerator.new(key)
        @encryptor = ::ActiveSupport::MessageEncryptor.new(key_generator.generate_key(salt, 32))
      end

      def encrypt(value)
        encryptor.encrypt_and_sign(super)
      end

      def decrypt(value)
        encryptor.decrypt_and_verify(super)
      end

      def ==(other)
        super && encryptor == other.encryptor
      end

      protected

      attr_reader :encryptor
    end
  end
end
