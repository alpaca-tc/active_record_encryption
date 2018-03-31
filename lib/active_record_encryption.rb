# frozen_string_literal: true

require 'active_record'
require 'active_support/core_ext/module/attribute_accessors_per_thread'

module ActiverecordEncryption
  require 'activerecord_encryption/version'
  require 'activerecord_encryption/serializer_with_cast'
  require 'activerecord_encryption/type'
  require 'activerecord_encryption/encryptor'
  require 'activerecord_encryption/encryptor/cipher'
  require 'activerecord_encryption/encrypted_attribute'
  require 'activerecord_encryption/quoter'
  require 'activerecord_encryption/exceptions'

  thread_mattr_accessor(:cipher)

  def self.with_cipher(new_cipher)
    previous = cipher
    self.cipher = new_cipher
    yield
  ensure
    self.cipher = previous
  end
end
