# frozen_string_literal: true

require 'active_record'
require 'activerecord_encryption/version'
require 'active_support/core_ext/module/attribute_accessors_per_thread'

module ActiverecordEncryption
  require 'activerecord_encryption/serializer_with_cast'
  require 'activerecord_encryption/type'
  require 'activerecord_encryption/cipher'
  require 'activerecord_encryption/cipher/aes256cbc'
  require 'activerecord_encryption/encrypted_attributes'
  require 'activerecord_encryption/encrypted_attributes/from_comment'
  require 'activerecord_encryption/core'
  require 'activerecord_encryption/exceptions'

  thread_mattr_accessor(:cipher)
end
