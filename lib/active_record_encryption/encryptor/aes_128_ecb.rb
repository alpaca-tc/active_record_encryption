# frozen_string_literal: true

require 'openssl'

module ActiveRecordEncryption
  module Encryptor
    class ActiveRecordEncryption::Encryptor::Aes128Ecb < Raw
      def initialize(key:, encoding: Encoding::UTF_8)
        @key = key
        @encoding = encoding
      end

      def encrypt(value)
        string = super.dup.force_encoding(encoding)
        encrypted_data = _encrypt(string, key)

        binary = Binary.new
        binary.write(encrypted_data)
        binary.string
      end

      def decrypt(value)
        binary         = Binary.new(value)
        encrypted_data = binary.read

        decrypted = _decrypt(encrypted_data, key)
        decrypted.force_encoding(encoding)
      end

      def ==(other)
        super &&
          key == other.key &&
          encoding == other.encoding
      end

      protected

      attr_reader :key, :encoding

      private

      def valid_encoding?(value)
        value.valid_encoding? && value.encoding == encoding
      end

      def _encrypt(value, key)
        raise ArgumentError, "invalid string given. #{value}" unless valid_encoding?(value)

        cipher = OpenSSL::Cipher.new('AES-128-ECB')
        cipher.encrypt
        cipher.key = key

        result = ''.dup.tap do |buffer|
          buffer << cipher.update(value) unless value.empty?
          buffer << cipher.final
        end

        result
      end

      def _decrypt(value, key)
        cipher = OpenSSL::Cipher.new('AES-128-ECB')
        cipher.decrypt
        cipher.key = key

        ''.dup.tap do |buffer|
          buffer << cipher.update(value)
          buffer << cipher.final
        end
      end
    end
  end
end
