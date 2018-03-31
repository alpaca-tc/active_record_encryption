# frozen_string_literal: true

require 'digest'

module ActiverecordEncryption
  module Testing
    class TestCipher < ActiverecordEncryption::Encryptor::Cipher
      attr_reader :key

      def initialize(key: SecureRandom.hex)
        @key = key
      end

      def ==(other)
        other.is_a?(self.class) && key == other.key
      end

      def encrypt(value)
        super("#{value}#{key}")
      end

      def decrypt(value)
        if value.match?(/#{key}$/)
          super(value.sub(/#{key}$/, ''))
        else
          raise InvalidMessage, 'invalid value given'
        end
      end
    end
  end
end
