# frozen_string_literal: true

module ActiverecordEncryption
  module EncryptedAttributes
    extend ActiveSupport::Concern

    module ClassMethods
      def encrypted_attributes(definitions)
        definitions.each do |name, type|
          name = name.to_s
          type = ActiveRecord::Type.lookup(type) if type.is_a?(Symbol)

          decorate_attribute_type(name, :encrypted) do |db_type|
            ActiverecordEncryption::Type.new(name, type, db_type)
          end

          singleton_class.define_method(name.pluralize) { mapping }
        end
      end
    end
  end
end
