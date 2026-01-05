# frozen_string_literal: true

require 'singleton'

module ActiveRecordEncryption
  # Serialize ruby object to string for encryption.
  class Quoter
    include ActiveRecord::ConnectionAdapters::Quoting
    include Singleton

    # minimum length of string for encryption
    def unquoted_true
      't'
    end

    # minimum length of string for encryption
    def unquoted_false
      'f'
    end

    # Cast value to string
    def type_cast(value)
      return value.to_s if value.is_a?(Numeric)
      super(value)
    end

    # @return [Symbol]
    def default_timezone
      ActiveRecord::Base.connection.default_timezone
    end
  end
end
