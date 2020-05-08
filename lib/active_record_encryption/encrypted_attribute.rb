# frozen_string_literal: true

module ActiveRecordEncryption
  module EncryptedAttribute
    extend ActiveSupport::Concern

    module ClassMethods
      def encrypted_attribute(name, subtype, **options)
        attribute(name, :encryption, **options.merge(subtype: subtype))
      end
    end
  end
end
