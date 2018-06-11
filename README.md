# ActiveRecordEncryption

Provides transparent encryption attribute for ActiveRecord. 
You can easily encrypt and decrypt sensitive data.

This implementation is based on ActiveRecord's Attribute-API, and it is very simple and powerful.

## Usage

Add definition of the encrypted attribute in your application. 

```ruby
# app/models/post.rb
class Post < ActiveRecord::Base
  encrypted_attribute(:name, :string)
end
```

That's all. This column is already enabled for transparent encryption.

```ruby
post = Post.create!(name: 'Baker')
post.name #=> "Baker"
post.name_before_type_cast #=> "ZS~\xAB\x8C\xD1\xCA\u0016\xA8\x80f@\xE8s\xB7J/\xA9\xEC/\xBDj\xDE6(Y\u007F\u0016<W\u0011\x96"
```

## Options

You can set encryption as default.

```ruby
# config/initializers/active_record_encryption.rb
ActiveRecordEncryption.default_encryption = {
  encryptor: :active_support,
  key: ENV['ENCRYPTION_KEY'],
  salt: ENV['ENCRYPTION_SALT']
}
```

### encrypted_attribute

`.encrypted_attribute()` wrapped on `.attribute` method. and you can pass the same arguments as [ActiveRecord::Attributes.attribute](https://apidock.com/rails/ActiveRecord/Attributes/ClassMethods/attribute)

```ruby
class PointLog < ActiveRecord::Base
  encrypted_attribute(:date, :date)
  encrypted_attribute(:point, :integer, default: -> { Current.user.current_point })
  encrypted_attribute(:price, Money.new)
  encrypted_attribute(:serialized_address, :string)

  # Change encryptor
  encrypted_attribute(:name, :field, encryption: { encryptor: :active_support, key: ENV['ENCRYPTION_KEY'], salt: ['ENCRYPTION_SALT'] })
end
```

## Supported Available Encryptors

There are four supported encryptors: `:active_support`, `:aes_256_cbc`.

- `:active_support`
  - Encryption is performed using `ActiveSupport::MessageEncryptor`
  - Example
    - `encrypted_attribute(:field, :type, encryption: { encryptor: :active_support, key: SecureRandom.hex(64), salt: SecureRandom.hex(64) })`
- `:aes_256_cbc`
  - Encryption is performed using `OpenSSL::Cipher.new('AES-256-CBC')`
  - Example
    - `encrypted_attribute(:field, :type, encryption: { encryptor: :aes_256_cbc, key: SecureRandom.hex(64) })`

## Customize encryptor

You can easilly add your encryptor.

```ruby
class YourEncryptor < ActiveRecordEncryption::Encryptor::Base
  def initialize(key:)
    @key = key
  end

  def encrypt(value)
    # An encrypt method that returns the encrypted string
  end

  def decrypt(value)
    # A decrypt method that returns the plaintext
  end
end

ActiveRecordEncryption.default_encryption = {
  encryptor: YourEncryptor,
  key: ENV['ENCRYPTION_KEY']
}
```

## Secret key/salt

For encryptors requiring secret keys, you can generate them.
These values should be stored outside of your application repository for added security. 

```bash
ruby -e "require 'securerandom'; puts SecureRandom.hex(64)"`
```

### Migration

Create or modify the table that your model like the following:

**NOTE: Default limit of ActiveRecord's binary column is too long. Please set limit(< 0xfff) for encrypted columns.**

```ruby
ActiveRecord::Schema.define do
  create_table(:posts) do |t|
    t.binary :name, limit: 1000
  end
end
```

### Run spec

```bash
bundle exec appraisal install
bundle exec appraisal 5.0-stable rspec
bundle exec appraisal 5.1-stable rspec
bundle exec appraisal 5.2-stable rspec
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/alpaca-tc/active_record_encryption. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the `ActiveRecord::Encryption` project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/alpaca-tc/active_record_encryption/blob/master/CODE_OF_CONDUCT.md).
