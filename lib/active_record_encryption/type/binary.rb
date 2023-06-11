module ActiveRecordEncryption
  class Type
    class Binary < ActiveModel::Type::Binary
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
