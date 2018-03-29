# frozen_string_literal: true

require 'openssl'

module ActiverecordEncryption
  class Cipher
    class Aes256cbc < Cipher
      attr_reader :password, :salt, :adapter_class

      def initialize(password:, salt: nil, adapter_class: ActiveRecord::Base)
        @password = password
        @salt = salt
        @adapter_class = adapter_class
      end

      def ==(other)
        password == other.password && salt == other.salt && adapter_class == other.adapter_class
      end

      def decrypt(value)
        cipher = OpenSSL::Cipher.new('AES-256-CBC')
        cipher.decrypt
        cipher.pkcs5_keyivgen(@password, @salt)

        ''.dup.tap do |binary|
          binary << cipher.update(value)
          binary << cipher.final
          binary.force_encoding('UTF-8')
        end
      end

      def encrypt(value)
        cipher = OpenSSL::Cipher.new('AES-256-CBC')
        cipher.encrypt
        cipher.pkcs5_keyivgen(@password, @salt)

        ''.dup.tap do |binary|
          binary << cipher.update(type_cast(value))
          binary << cipher.final
        end
      end

      private

      def type_cast(value)
        quoted_value = @adapter_class.connection.type_cast(value)
        quoted_value = quoted_value.to_s if quoted_value.is_a?(Numeric)
        quoted_value
      end
    end
  end
end
