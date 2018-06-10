# frozen_string_literal: true

module ActiveRecordEncryption
  module Encryptor
    # Abstract interface of encryptor
    class Base
      def initialize(*); end

      def encrypt(value)
        value
      end

      def decrypt(value)
        value
      end

      def ==(other)
        self.class == other.class
      end

      alias eql? ==
    end
  end
end
