# frozen_string_literal: true

module ActiveRecordEncryption
  module Encryptor
    # Basic base class of encryptor.
    # Format user input to string before encryption.
    class Raw < Base
      def encrypt(value)
        ActiveRecordEncryption::Quoter.instance.type_cast(super)
      end
    end
  end
end
