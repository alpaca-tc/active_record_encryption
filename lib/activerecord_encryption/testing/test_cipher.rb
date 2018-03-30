# frozen_string_literal: true

require 'digest'

module ActiverecordEncryption
  module Testing
    class TestCipher < ActiverecordEncryption::Cipher
      attr_reader :key

      def initialize(key: SecureRandom.hex)
        @key = key
      end

      def ==(other)
        other.is_a?(self.class) && key == other.key
      end

      def encrypt(value)
        super("#{value}#{digest}")
      end

      def decrypt(value)
        if value.match?(/#{digest}$/)
          super(value.sub(/#{digest}$/, ''))
        else
          raise InvalidMessage, 'invalid value given'
        end
      end

      private

      def digest
        Digest::SHA256.digest(key)
      end
    end
  end
end
