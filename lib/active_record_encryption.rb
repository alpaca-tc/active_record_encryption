# frozen_string_literal: true

require 'active_record'
require 'active_support/core_ext/module/attribute_accessors_per_thread'

module ActiveRecordEncryption
  require 'active_record_encryption/version'
  require 'active_record_encryption/serializer_with_cast'
  require 'active_record_encryption/type'
  require 'active_record_encryption/encryptor'
  require 'active_record_encryption/encrypted_attribute'
  require 'active_record_encryption/quoter'
  require 'active_record_encryption/exceptions'
  require 'active_record_encryption/binary'

  mattr_accessor(:default_encryption, instance_accessor: false) do
    { encryptor: :raw }
  end
end

ActiveSupport.on_load(:active_record) do
  ActiveRecord::Type.register(:encryption, ActiveRecordEncryption::Type)
end
