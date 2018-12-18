## 0.2.1

- Fixes #13 Add `:cipher` option to `active_support` encryptor to change cipher.

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
  - AES-256-CBC
    - `encrypted_attribute(:field, :type, encryption: { encryptor: :aes_256_cbc, key: ENV['KEY'] })`

### Bug fixes

- `ActiveRecordEncryption::Type#change_in_place?` Compare old value with new value.
- `ActiveRecordEncryption::Type#cast` supports TimeWithZone

### Changes

- Remove `ActiveRecordEncryption.with_cipher`
- Remove `ActiveRecordEncryption.cipher`
- Now, base class of Encryption is `ActiveRecordEncryption::Encryptor::Base`

## 0.1.1

- [#1](https://github.com/alpaca-tc/active_record_encryption/pull/1) Support only binary column

## 0.1.0

- First release
