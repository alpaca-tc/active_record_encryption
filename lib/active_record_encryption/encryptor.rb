# frozen_string_literal: true

module ActiveRecordEncryption
  module Encryptor
    class << self
      def encrypt(value, cipher: ActiveRecordEncryption.cipher)
        raise_missing_cipher_error unless cipher

        string = value_to_string(value)
        cipher.encrypt(string)
      end

      def decrypt(value, cipher: ActiveRecordEncryption.cipher)
        raise_missing_cipher_error unless cipher
        cipher.decrypt(value)
      end

      private

      def value_to_string(value)
        ActiveRecordEncryption::Quoter.instance.type_cast(value)
      end

      def raise_missing_cipher_error
        raise(ActiveRecordEncryption::MissingCipherError, 'missing cipher')
      end
    end
  end
end
