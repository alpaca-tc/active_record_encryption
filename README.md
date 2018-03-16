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
    t.string :string
    t.text   :text
    t.string :date
    t.string :datetime
    t.string :time
    t.string :integer
    t.string :float
    t.string :decimal
    t.string :boolean
  end
end

class Post < ActiveRecord::Base
  include ActiverecordEncryption

  encrypted_attributes(
    secret_string: :string,
    secret_date: :date,
    secret_datetime: :datetime,
    secret_time: :time,
    secret_integer: :integer,
    secret_float: :float,
    secret_decimal: :decimal,
    secret_boolean: :boolean
  )
end

> ActiverecordEncryption.cipher = cipher
> post = Post.new(string: 'string', text: 'text', date: Date.today, datetime: DateTime.now, time: Time.now, integer: 1, float: 1.1, decimal: 1.1, boolean: false)
=> #<Post:0x00007fd811b267b8
 id: nil,
 string: "string",
 text: "text",
 date: Fri, 16 Mar 2018,
 datetime: Fri, 16 Mar 2018 21:24:33 +0900,
 time: 2018-03-16 21:24:33 +0900,
 integer: 1,
 float: 1.1,
 decimal: 0.11e1,
 boolean: false>

> post.save
DEBUG -- :    (0.1ms)  begin transaction
DEBUG -- :   SQL (0.1ms)  INSERT INTO "posts" ("string", "text", "date", "datetime", "time", "integer", "float", "decimal", "boolean") VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)  [["string", "@\xCA\xC9\e\u001D\xFE\xBA\x88\xD2\u001AX\xD9Г1n"], ["text", "\xCD\xCD\xF4lJ\xF3'\u0019\xA5b\xCDV\bj\xAC\u001C"], ["date", "T]\xAF\u0002\u0004\t\xACL\xEFt\xCC`\xE2\xC3\u0003\xAA"], ["datetime", "95՝\xE3\u0005\xC3\xCD\xE8\x8Br\x826s\u0016~\xAAa\xB8Ķ%\u0002a^\u001D\xA1{\xCA:ʢ"], ["time", "95՝\xE3\u0005\xC3\xCD\xE8\x8Br\x826s\u0016~\xBD\vk\xA99H\xD9,k\xB9\xA0\xB7Q\xB4\u001A\xB4"], ["integer", "\xC7>\u0092C\x9F\xFDӭ\xC1\x87\n\xE9\xF1#\xE6"], ["float", "\xF0+2ܞ\xE7\x95V\xC2k\x85\x97\u001Eδ\xAB"], ["decimal", "\xF0+2ܞ\xE7\x95V\xC2k\x85\x97\u001Eδ\xAB"], ["boolean", "x-\xBC\e\xCE\xEB\x94\xE0\xF5s\xCA-m\x85\u0001\xA8"]]
DEBUG -- :    (0.1ms)  commit transaction

> post = Post.find(post.id)
DEBUG -- :   Post Load (0.1ms)  SELECT  "posts".* FROM "posts" WHERE "posts"."id" = ? LIMIT ?  [["id", 1], ["LIMIT", 1]]
=> #<Post:0x00007fd811195848
 id: 1,
 string: "string",
 text: "text",
 date: Fri, 16 Mar 2018,
 datetime: 2018-03-16 12:24:33 UTC,
 time: 2000-01-01 12:24:33 UTC,
 integer: 1,
 float: 1.1,
 decimal: 0.11e1,
 boolean: false>

> Post.connection.exec_query("SELECT * FROM posts WHERE id = #{post.id}")
DEBUG -- :    (0.4ms)  SELECT * FROM posts WHERE id = 1
=> #<ActiveRecord::Result:0x00007fd810a1f078
 @column_types={},
 @columns=["id", "string", "text", "date", "datetime", "time", "integer", "float", "decimal", "boolean"],
 @hash_rows=nil,
 @rows=
  [[1,
    "@\xCA\xC9\e\u001D\xFE\xBA\x88\xD2\u001AX\xD9Г1n",
    "\xCD\xCD\xF4lJ\xF3'\u0019\xA5b\xCDV\bj\xAC\u001C",
    "T]\xAF\u0002\u0004\t\xACL\xEFt\xCC`\xE2\xC3\u0003\xAA",
    "95՝\xE3\u0005\xC3\xCD\xE8\x8Br\x826s\u0016~\xAAa\xB8Ķ%\u0002a^\u001D\xA1{\xCA:ʢ",
    "95՝\xE3\u0005\xC3\xCD\xE8\x8Br\x826s\u0016~\xBD\vk\xA99H\xD9,k\xB9\xA0\xB7Q\xB4\u001A\xB4",
    "\xC7>\u0092C\x9F\xFDӭ\xC1\x87\n\xE9\xF1#\xE6",
    "\xF0+2ܞ\xE7\x95V\xC2k\x85\x97\u001Eδ\xAB",
    "\xF0+2ܞ\xE7\x95V\xC2k\x85\x97\u001Eδ\xAB",
    "x-\xBC\e\xCE\xEB\x94\xE0\xF5s\xCA-m\x85\u0001\xA8"]]>
```

## Change cipher

```ruby
class ApplicationController < ActionController::Base
  before_action :authenticate_user!

  before_action do
    ActiverecordEncryption.cipher = ActiverecordEncryption::Cipher::Aes256cbc.new(
      password: 'xxxx',
      salt: current_uesr.salt
    )
  end
end
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/activerecord_encryption. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Activerecord::Encryption project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/activerecord_encryption/blob/master/CODE_OF_CONDUCT.md).
