# frozen_string_literal: true

module ActiverecordEncryption
  class Type < ActiveRecord::Type::Value
    using(ActiverecordEncryption::SerializerWithCast)

    delegate :type, to: :db_type
    delegate :cast, to: :subtype

    def initialize(name, subtype, db_type)
      @name = name
      @subtype = subtype
      @db_type = db_type
    end

    def deserialize(value)
      deserialized = db_type.deserialize(value)
      subtype.deserialize(decrypt(deserialized)) unless deserialized.nil?
    end

    def serialize(value)
      serialized = subtype.serialize(value)
      db_type.serialize(encrypt(serialized)) unless serialized.nil?
    end

    private

    attr_reader :name, :subtype, :db_type

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
