# frozen_string_literal: true

module ActiverecordEncryption
  module Encryptor
    class << self
      def encrypt(value, cipher: ActiverecordEncryption.cipher)
        raise_missing_cipher_error unless cipher

        string = value_to_string(value)
        cipher.encrypt(string)
      end

      def decrypt(value, cipher: ActiverecordEncryption.cipher)
        raise_missing_cipher_error unless cipher
        cipher.decrypt(value)
      end

      private

      def value_to_string(value)
        ActiverecordEncryption::Quoter.instance.type_cast(value)
      end

      def raise_missing_cipher_error
        raise(ActiverecordEncryption::MissingCipherError, 'missing cipher')
      end
    end
  end
end
