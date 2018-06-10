# frozen_string_literal: true

require 'active_support/core_ext/module/attribute_accessors'
require 'active_support/lazy_load_hooks'
require 'active_record_encryption/version'
require 'active_record_encryption/exceptions'

module ActiveRecordEncryption
  mattr_accessor(:default_encryption, instance_accessor: false) do
    { encryptor: :raw }
  end
end

ActiveSupport.on_load(:active_record) do
  require 'active_record_encryption/type'
  require 'active_record_encryption/encryptor'
  require 'active_record_encryption/encrypted_attribute'
  require 'active_record_encryption/binary'
  require 'active_record_encryption/quoter'

  # Register `:encryption` type
  ActiveRecord::Type.register(:encryption, ActiveRecordEncryption::Type)

  # Define `.encrypted_attribute`
  ActiveRecord::Base.include(ActiveRecordEncryption::EncryptedAttribute)
end
