module ActiveRecordEncryption
  class Type
    class Binary < ActiveModel::Type::Binary
      def cast(value)
        return super if ActiveRecord::VERSION::STRING < '7.0.0'

        if value.is_a?(Data)
          value.to_s
        else
          value = cast_value(value) unless value.nil?
          # NOTE: Don't convert string to binary for backward compatibility.
          # value = value.b if ::String === value && value.encoding != Encoding::BINARY
          value
        end
      end

      def serialize(value)
        return if value.nil?
        Data.new(value)
      end

      class Data < ActiveModel::Type::Binary::Data
        # NOTE: Don't convert string to binary for backward compatibility.
        def initialize(value)
          @value = value.to_s
        end
      end
    end
  end
end
