# frozen_string_literal: true

module ActiverecordEncryption
  class Quoter
    include ActiveRecord::ConnectionAdapters::Quoting

    private

    # Cast value to string
    def _type_cast(value)
      return value.to_s if value.is_a?(Numeric)
      super(value)
    end
  end
end
