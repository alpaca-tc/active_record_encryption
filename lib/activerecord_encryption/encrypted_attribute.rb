# frozen_string_literal: true

module ActiverecordEncryption
  module EncryptedAttribute
    extend ActiveSupport::Concern

    module ClassMethods
      def encrypted_attribute(name, subtype, **options)
        name = name.to_s
        subtype = ActiveRecord::Type.lookup(subtype, **options.except(:default)) if subtype.is_a?(Symbol)

        # Define user provided attribute when options contains :default
        attribute(name, subtype, **options) if options.key?(:default)

        decorate_attribute_type(name, :encrypted) do |db_type|
          ActiverecordEncryption::Type.new(name, subtype, db_type)
        end
      end
    end
  end
end
