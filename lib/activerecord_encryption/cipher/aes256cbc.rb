# frozen_string_literal: true

require 'openssl'

module ActiverecordEncryption
  class Cipher
    class Aes256cbc < Cipher
      attr_reader :key, :iv

      def initialize(key:, iv: '')
        @key = key
        @iv = iv
      end

      def ==(other)
        other.is_a?(self.class) && key == other.key && iv == other.iv
      end

      def decrypt(value)
        cipher = OpenSSL::Cipher.new('AES-256-CBC')
        cipher.decrypt
        cipher.key = key
        cipher.iv = iv

        # FIXME: Why need 'force_encoding' ?
        (cipher.update(value) + cipher.final).force_encoding('UTF-8')
      end

      def encrypt(value)
        cipher = OpenSSL::Cipher.new('AES-256-CBC')
        cipher.encrypt
        cipher.key = key
        cipher.iv = iv
        cipher.update(value) + cipher.final
      end
    end
  end
end
