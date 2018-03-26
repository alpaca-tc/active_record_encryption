# frozen_string_literal: true

module ActiverecordEncryption
  module EncryptedAttribute
    extend ActiveSupport::Concern

    module ClassMethods
      def encrypted_attribute(name, type, *options)
        name = name.to_s
        type = ActiveRecord::Type.lookup(type, *options) if type.is_a?(Symbol)

        decorate_attribute_type(name, :encrypted) do |db_type|
          ActiverecordEncryption::Type.new(name, type, db_type)
        end
      end
    end
  end
end
