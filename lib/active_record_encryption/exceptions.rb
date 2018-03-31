# frozen_string_literal: true

module ActiverecordEncryption
  class Error < StandardError; end
  class MissingCipherError < Error; end
  class InvalidMessage < Error; end
end
