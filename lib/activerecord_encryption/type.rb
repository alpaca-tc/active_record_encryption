# frozen_string_literal: true

module ActiverecordEncryption
  class Type < ActiveRecord::Type::Value
    delegate :type, to: :subtype

    attr_reader :name, :subtype, :db_type

    def initialize(name, subtype, db_type)
      @name = name
      @subtype = subtype
      @db_type = db_type
    end

    def cast(value)
      subtype.cast(value)
    end

    def deserialize(value)
      return if value.nil?

      decrypted = decrypt(value)
      @subtype.deserialize(decrypted)
    end

    def serialize(value)
      return if value.nil?

      serialized = type_cast_for_database(@subtype.serialize(value))
      type_cast_for_database(encrypt(serialized)) if serialized
    end

    private

    def type_cast_for_database(value)
      ActiveRecord::Base.connection.type_cast(value)
    end

    def decrypt(value)
      cipher.decrypt(value)
    end

    def encrypt(value)
      cipher.encrypt(value)
    end

    def cipher
      ActiverecordEncryption.cipher || raise(ActiverecordEncryption::MissingCipherError, 'missing cipher')
    end
  end
end
