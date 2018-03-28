# frozen_string_literal: true

module ActiverecordEncryption
  module EncryptedAttribute
    extend ActiveSupport::Concern

    module ClassMethods
      def encrypted_attribute(name, subtype, **options)
        name = name.to_s

        attribute(name, subtype, **options)
        decorate_encrypted_attribute(name)
      end

      private

      def decorate_encrypted_attribute(name)
        decorate_attribute_type(name, :encrypted) do |subtype|
          ActiverecordEncryption::Type.new(name, subtype)
        end
      end
    end
  end
end
