# [WIP] ActiverecordEncryption

ARの機能を使って、透過的に暗号化を行いたい。

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'activerecord_encryption'
```

## Usage

```ruby
ActiveRecord::Schema.define do
  create_table(:posts, force: true) do |t|
    t.binary :string
    t.binary :text
    t.binary :date
    t.binary :datetime
    t.binary :time
    t.binary :integer
    t.binary :float
    t.binary :decimal
    t.binary :boolean
  end
end

class Post < ActiveRecord::Base
  include ActiverecordEncryption::EncryptedAttribute

  encrypted_attribute(:string, :string)
  encrypted_attribute(:date, :date)
  encrypted_attribute(:datetime, :datetime)
  encrypted_attribute(:time, :time)
  encrypted_attribute(:integer, :integer)
  encrypted_attribute(:float, :float)
  encrypted_attribute(:decimal, :decimal)
  encrypted_attribute(:boolean, :boolean)
end

# Set cipher
> cipher = ActiverecordEncryption::Cipher::Aes256cbc.new(password: OpenSSL::Random.random_bytes(8), salt: OpenSSL::Random.random_bytes(8))
> ActiverecordEncryption.cipher = cipher

# Transparently encrypt/decrypt attributes.
> post = Post.new(string: 'string', text: 'text', date: Date.today, datetime: DateTime.now, time: Time.now, integer: 1, float: 1.1, decimal: 1.1, boolean: false)
=> #<Post:0x00007f92169ac158
 id: nil,
 string: "string",
 text: "text",
 date: Mon, 26 Mar 2018,
 datetime: Mon, 26 Mar 2018 20:32:13 +0900,
 time: 2018-03-26 20:32:13 +0900,
 integer: 1,
 float: 1.1,
 decimal: 0.11e1,
 boolean: false>

> post.save
DEBUG -- :    (0.1ms)  begin transaction
DEBUG -- :   Post Create (0.1ms)  INSERT INTO "posts" ("string", "text", "date", "datetime", "time", "integer", "float", "decimal", "boolean") VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)  [["string", "N\xFA\xDD\xC2\xB0&\xAE\x9A\xDE\xBA\x8ED\x9F\xB6\xC9\xDD"], ["text", "<4 bytes of binary data>"], ["date", "\xEC\x13\xF6\xA9L\xF6Z\xA6%\xE4\xBB\xE0c\x87\xEB<"], ["datetime", "~J\x9CX\xB3\xB9z\xAF4\xF4G\x16\xEAT[7b~SA6\xEBn&x\xD8\xA2\x86\xA2\xAA\xCEl"], ["time", "~J\x9CX\xB3\xB9z\xAF4\xF4G\x16\xEAT[7b~SA6\xEBn&x\xD8\xA2\x86\xA2\xAA\xCEl"], ["integer", "\x16\x1Do\xDF\xB5\x14o\xC0\xCCR\x9A\xEF\\\xDB\xC2\x8B"], ["float", "&\x12\xBD^z\xE5F\xB6\x81#\b\xED\xE8,\xB4\x94"], ["decimal", "&\x12\xBD^z\xE5F\xB6\x81#\b\xED\xE8,\xB4\x94"], ["boolean", "b\x9A\xFD\xFE\xBB-\x93Z\xF6,\xEB\x12~\xF1>\xC4"]]
DEBUG -- :    (0.0ms)  commit transaction

> post = Post.find(post.id)
DEBUG -- :   Post Load (0.1ms)  SELECT  "posts".* FROM "posts" WHERE "posts"."id" = ? LIMIT ?  [["id", 2], ["LIMIT", 1]]
=> #<Post:0x00007f9217260c90
 id: 2,
 string: "string",
 text: "text",
 date: Mon, 26 Mar 2018,
 datetime: 2018-03-26 11:32:41 UTC,
 time: 2000-01-01 11:32:41 UTC,
 integer: 1,
 float: 1.1,
 decimal: 0.11e1,
 boolean: false>

# Data is encrypted in DB
> Post.connection.exec_query("SELECT * FROM posts WHERE id = #{post.id}")
DEBUG -- :    (0.1ms)  SELECT * FROM posts WHERE id = 2
=> #<ActiveRecord::Result:0x00007f921624ff68
 @column_types={},
 @columns=["id", "string", "text", "date", "datetime", "time", "integer", "float", "decimal", "boolean"],
 @hash_rows=nil,
 @rows=
  [[2,
    "N\xFA\xDD\xC2\xB0&\xAE\x9A\xDE\xBA\x8ED\x9F\xB6\xC9\xDD",
    "text",
    "\xEC\x13\xF6\xA9L\xF6Z\xA6%\xE4\xBB\xE0c\x87\xEB<",
    "~J\x9CX\xB3\xB9z\xAF4\xF4G\x16\xEAT[7b~SA6\xEBn&x\xD8\xA2\x86\xA2\xAA\xCEl",
    "~J\x9CX\xB3\xB9z\xAF4\xF4G\x16\xEAT[7b~SA6\xEBn&x\xD8\xA2\x86\xA2\xAA\xCEl",
    "\x16\x1Do\xDF\xB5\x14o\xC0\xCCR\x9A\xEF\\\xDB\xC2\x8B",
    "&\x12\xBD^z\xE5F\xB6\x81#\b\xED\xE8,\xB4\x94",
    "&\x12\xBD^z\xE5F\xB6\x81#\b\xED\xE8,\xB4\x94",
    "b\x9A\xFD\xFE\xBB-\x93Z\xF6,\xEB\x12~\xF1>\xC4"]]>
```

## Change cipher in your controller

```ruby
class ApplicationController < ActionController::Base
  before_action :authenticate_user!

  before_action do
    ActiverecordEncryption.cipher = ActiverecordEncryption::Cipher::Aes256cbc.new(
      password: current_uesr.generate_salt,
      salt: 'XXX'
    )
  end
end
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

### Run spec

```
bundle exec appraisal install
bundle exec appraisal 4.2-stable rspec
bundle exec appraisal 5.0-stable rspec
bundle exec appraisal 5.1-stable rspec
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/alpaca-tc/activerecord_encryption. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Activerecord::Encryption project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/alpaca-tc/activerecord_encryption/blob/master/CODE_OF_CONDUCT.md).
