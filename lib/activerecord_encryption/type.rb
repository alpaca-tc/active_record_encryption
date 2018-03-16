module ActiverecordEncryption
  class Type < ActiveRecord::Type::Value
    delegate :type, to: :subtype

    attr_reader :name, :subtype

    def initialize(name, subtype)
      @name = name
      @subtype = subtype
    end

    def cast(value)
      @subtype.cast(value)
    end

    def deserialize(value)
      value
    end

    def serialize(value)
      value
    end
  end
end
