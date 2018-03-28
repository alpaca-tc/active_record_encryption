# frozen_string_literal: true

module ActiverecordEncryption
  module CommentSchema
    extend ActiveSupport::Concern

    included do |_klass|
      include ActiverecordEncryption::EncryptedAttribute
      include ActiverecordSchemaHook::HookInjection

      ActiverecordSchemaHook::Hooks.register(:encryption) do |klass|
        ActiverecordEncryption::CommentSchema.install_encrypted_attributes(klass)
      end
    end

    class EncryptedAttributeDefinitionFromComment
      EncryptedAttributeDefinition = Struct.new(:name, :type, :options)

      DEFINITION_RE = /encrypted_attribute\(:(?<type>[^\)]+)\)/

      def initialize(klass)
        @klass = klass
        @columns = klass.columns
      end

      def encrypted_attribute_definitions
        columns.map { |column| build_encrypted_attribute_definition(column) }.compact
      end

      private

      def build_encrypted_attribute_definition(column)
        return unless column.comment
        return unless column.comment.match(DEFINITION_RE)

        name = column.name
        type = Regexp.last_match[:type]

        EncryptedAttributeDefinition.new(name, type, {})
      end

      attr_reader :klass, :columns
    end

    def self.install_encrypted_attributes(klass)
      from_comment = EncryptedAttributeDefinitionFromComment.new(klass)

      from_comment.encrypted_attribute_definitions.each do |encrypted_definition|
        next if attribute_encryption_decorated?(klass, encrypted_definition.name) # already encrypted
        klass.encrypted_attribute(encrypted_definition.name, encrypted_definition.type.to_sym, **encrypted_definition.options)
      end
    end

    # FIXME: This method depends on private api in activerecord/lib/active_record/attribute_decorators.rb
    def self.attribute_encryption_decorated?(klass, name)
      decorator_name = "_#{name}_encrypted"
      klass.attribute_type_decorations.instance_variable_get(:@decorations).key?(decorator_name)
    end
  end
end
