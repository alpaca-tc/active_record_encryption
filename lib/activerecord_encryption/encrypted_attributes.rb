# frozen_string_literal: true

module ActiverecordEncryption
  module EncryptedAttributes
    extend ActiveSupport::Concern

    INVALID_ENCRYPTED_ATTRIBUTE_TYPES = [
      ActiveRecord::Type::Boolean
    ].to_set.freeze

    module ClassMethods
      def encrypted_attributes(definitions)
        definitions.each do |name, type|
          define_encrypted_attribute(name, type)
        end
      end

      private

      def define_encrypted_attribute(name, type)
        name = name.to_s
        type = ActiveRecord::Type.lookup(type) if type.is_a?(Symbol)
        assert_encrypted_attribute_type!(type)

        decorate_attribute_type(name, :encrypted) do |db_type|
          ActiverecordEncryption::Type.new(name, type, db_type)
        end
      end

      def assert_encrypted_attribute_type!(type)
        return unless INVALID_ENCRYPTED_ATTRIBUTE_TYPES.include?(type.class)
        raise TypeError, "#{type.class} is unsupported type"
      end
    end
  end
end
