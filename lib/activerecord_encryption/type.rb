# frozen_string_literal: true

module ActiverecordEncryption
  class Type < ActiveRecord::Type::Value
    using(ActiverecordEncryption::SerializerWithCast)

    delegate :type, :cast, to: :subtype

    def initialize(name, subtype)
      @name = name
      @subtype = subtype
    end

    def deserialize(value)
      subtype.deserialize(decrypt(value)) unless value.nil?
    end

    def serialize(value)
      serialized = subtype.serialize(value)
      encrypt(serialized) unless serialized.nil?
    end

    private

    attr_reader :name, :subtype

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
