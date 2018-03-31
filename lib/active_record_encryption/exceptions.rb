# frozen_string_literal: true

module ActiveRecordEncryption
  class Error < StandardError; end
  class MissingCipherError < Error; end
  class InvalidMessage < Error; end
end
