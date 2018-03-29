# frozen_string_literal: true

require 'openssl'

module ActiverecordEncryption
  class Cipher
    class Aes256ecb < Cipher
      def initialize(key:, iv:)
        @key = key
        @iv = iv
      end

      def decrypt(value)
        cipher = OpenSSL::Cipher.new('AES-256-ECB')
        cipher.decrypt
        cipher.key = key
        cipher.iv = iv

        cipher.update(value) + cipher.final
      end

      def encrypt(value)
        cipher = OpenSSL::Cipher.new('AES-256-ECB')
        cipher.encrypt
        cipher.key = key
        cipher.iv = iv

        cipher.update(value) + cipher.final
      end

      private

      attr_reader :key, :iv
    end
  end
end
