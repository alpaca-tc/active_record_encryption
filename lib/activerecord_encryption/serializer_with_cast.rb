# frozen_string_literal: true

module ActiverecordEncryption
  module SerializerWithCast
    refine ActiveModel::Type::Decimal do
      def serialize(value)
        cast(value)
      end
    end

    refine ActiveModel::Type::Boolean do
      def serialize(value)
        cast(value)
      end
    end
  end
end
