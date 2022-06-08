# frozen_string_literal: true

require 'active_record_encryption/serializer_with_cast'

module ActiveRecordEncryption
  class Type < ActiveRecord::Type::Value
    using(ActiveRecordEncryption::SerializerWithCast)

    delegate :type, :cast, to: :subtype
    delegate :user_input_in_time_zone, to: :subtype # for ActiveRecord::AttributeMethods::TimeZoneConversion::TimeZoneConverter

    def initialize(
      subtype: default_value,
      encryption: ActiveRecordEncryption.default_encryption.clone,
      **options
    )
      super(**options.slice(:precision, :limit, :scale))

      # Lookup encryptor from options[:encryption]
      @encryptor = build_encryptor(encryption)
      @binary = ActiveRecord::Type.lookup(:binary)

      subtype = ActiveRecord::Type.lookup(subtype, **options) if subtype.is_a?(Symbol)
      @subtype = subtype
    end

    def deserialize(value)
      deserialized = binary.deserialize(value)
      subtype.deserialize(encryptor.decrypt(deserialized)) unless deserialized.nil?
    end

    def serialize(value)
      serialized = subtype.serialize(value)
      binary.serialize(encryptor.encrypt(serialized)) unless serialized.nil?
    end

    def changed_in_place?(raw_old_value, value)
      old_value = deserialize(raw_old_value)
      @subtype.changed_in_place?(old_value, value)
    end

    private

    attr_reader :subtype, :binary, :encryptor

    # NOTE: `ActiveRecord::Type.default_value` is not defined in Rails 5.0
    def default_value
      if ActiveRecord.gem_version < Gem::Version.create('5.1.0')
        ActiveRecord::Type::Value.new
      else
        ActiveRecord::Type.default_value
      end
    end

    def build_encryptor(options)
      encryptor = options.delete(:encryptor)

      case encryptor
      when Symbol
        ActiveRecordEncryption::Encryptor.lookup(encryptor, **options)
      when Class
        encryptor.new(**options)
      else
        encryptor
      end
    end
  end
end
