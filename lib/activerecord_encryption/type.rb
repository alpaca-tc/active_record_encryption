# frozen_string_literal: true

module ActiverecordEncryption
  class Type < ActiveRecord::Type::Value
    using(ActiverecordEncryption::SerializerWithCast)

    delegate :type, :cast, to: :subtype

    def initialize(name, subtype)
      @name = name
      @subtype = subtype
      @binary = ActiveRecord::Type.lookup(:binary)
    end

    def deserialize(value)
      deserialized = binary.deserialize(value)
      subtype.deserialize(decrypt(deserialized)) unless deserialized.nil?
    end

    def serialize(value)
      serialized = subtype.serialize(value)
      binary.serialize(encrypt(serialized)) unless serialized.nil?
    end

    private

    attr_reader :name, :subtype, :binary

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
