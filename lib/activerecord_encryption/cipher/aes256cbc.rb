# frozen_string_literal: true

require 'openssl'

module ActiverecordEncryption
  class Cipher
    class Aes256cbc < Cipher
      def initialize(password:, salt:)
        @password = password
        @salt = salt
      end

      def decrypt(value)
        cipher = OpenSSL::Cipher.new('AES-256-CBC')
        cipher.decrypt
        cipher.pkcs5_keyivgen(@password, @salt)

        from_cipher(cipher, value)
      end

      def encrypt(value)
        cipher = OpenSSL::Cipher.new('AES-256-CBC')
        cipher.encrypt
        cipher.pkcs5_keyivgen(@password, @salt)

        from_cipher(cipher, value)
      end

      private

      def from_cipher(cipher, value)
        result = ''.dup
        result << cipher.update(value.to_s)
        result << cipher.final
        result.force_encoding('UTF-8')
      end
    end
  end
end
