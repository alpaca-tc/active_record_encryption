# frozen_string_literal: true

require 'openssl'

module ActiveRecordEncryption
  module Encryptor
    class ActiveRecordEncryption::Encryptor::Aes256Cbc < Raw
      def initialize(key:, encoding: Encoding::UTF_8)
        super()
        @key = key
        @encoding = encoding
      end

      def encrypt(value)
        string = super.dup.force_encoding(encoding)
        encrypted_data, iv = _encrypt(string, key)

        binary = Binary.new
        binary.write(iv) # IV is 16 byte
        binary.write(encrypted_data)
        binary.string
      end

      def decrypt(value)
        binary         = Binary.new(value)
        iv             = binary.read(16)
        encrypted_data = binary.read

        decrypted = _decrypt(encrypted_data, key, iv)
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

        cipher = OpenSSL::Cipher.new('AES-256-CBC')
        cipher.encrypt
        cipher.key = key
        iv = cipher.random_iv # NOTE: Do not reuse IV. See more details https://stackoverflow.com/questions/3008139/why-is-using-a-non-random-iv-with-cbc-mode-a-vulnerability

        result = ''.dup.tap do |buffer|
          buffer << cipher.update(value) unless value.empty?
          buffer << cipher.final
        end

        [result, iv]
      end

      def _decrypt(value, key, iv)
        cipher = OpenSSL::Cipher.new('AES-256-CBC')
        cipher.decrypt
        cipher.key = key
        cipher.iv = iv

        ''.dup.tap do |buffer|
          buffer << cipher.update(value)
          buffer << cipher.final
        end
      end
    end
  end
end
