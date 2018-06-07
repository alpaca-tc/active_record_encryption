## 0.2.0

### New features

- Find custom encryptor by `:encryption` options
  - `encrypted_attribute(:field, :type, encryption: { encryptor: :active_support })`
- Register your encryption
  - `ActiveRecordEncryption::Type.register`
- Lookup your encryption
  - `ActiveRecordEncryption::Type.lookup`
- Add `ActiveRecordEncryption.default_encryptor`
- Buildin some encryption
  - ActiveSupport
    - `encrypted_attribute(:field, :type, encryption: { encryptor: :active_support, key: ENV['KEY'], salt: ENV['SALT'] })`

### Changes

- Remove `ActiveRecordEncryption.with_cipher`
- Remove `ActiveRecordEncryption.cipher`
- Now, base class of Encryption is `ActiveRecordEncryption::Encryptor::Base`

## 0.1.1

- [#1](https://github.com/alpaca-tc/active_record_encryption/pull/1) Support only binary column

## 0.1.0

- First release
