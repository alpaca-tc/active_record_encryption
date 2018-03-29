# frozen_string_literal: true

require 'openssl'

module ActiverecordEncryption
  class Cipher
    class Aes256cbc < Cipher
      attr_reader :password, :salt

      def initialize(password:, salt: nil)
        @password = password
        @salt = salt
      end

      def ==(other)
        other.is_a?(self.class) && password == other.password && salt == other.salt
      end

      def decrypt(value)
        cipher = OpenSSL::Cipher.new('AES-256-CBC')
        cipher.decrypt
        cipher.pkcs5_keyivgen(@password, @salt)

        ''.dup.tap do |binary|
          binary << cipher.update(value)
          binary << cipher.final
          binding.pry
          binary.encode('UTF-8')
        end
      end

      def encrypt(value)
        cipher = OpenSSL::Cipher.new('AES-256-CBC')
        cipher.encrypt
        cipher.pkcs5_keyivgen(@password, @salt)

        ''.dup.tap do |binary|
          binary << cipher.update(value)
          binary << cipher.final
        end
      end
    end
  end
end
