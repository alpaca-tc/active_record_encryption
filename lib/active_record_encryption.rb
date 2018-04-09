# frozen_string_literal: true

require 'active_record'
require 'active_support/core_ext/module/attribute_accessors_per_thread'

module ActiveRecordEncryption
  require 'active_record_encryption/version'
  require 'active_record_encryption/serializer_with_cast'
  require 'active_record_encryption/type'
  require 'active_record_encryption/encryptor'
  require 'active_record_encryption/encryptor/cipher'
  require 'active_record_encryption/encrypted_attribute'
  require 'active_record_encryption/quoter'
  require 'active_record_encryption/exceptions'

  thread_mattr_accessor(:cipher)

  def self.with_cipher(new_cipher)
    previous = cipher
    self.cipher = new_cipher
    yield
  ensure
    self.cipher = previous
  end
end

ActiveSupport.on_load(:active_record) do
  ActiveRecord::Type.register(:encryption, ActiveRecordEncryption::Type)
end
