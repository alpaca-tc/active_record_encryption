# frozen_string_literal: true

ActiveRecord::Base.establish_connection(adapter: 'sqlite3', database: ':memory:')

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

class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  include ActiverecordEncryption::Core
end

class Post < ApplicationRecord
  has_many :comments

  encrypted_attributes(
    string: :string,
    text: :text,
    date: :date,
    datetime: :datetime,
    time: :time,
    integer: :integer,
    float: :float,
    decimal: :decimal,
    boolean: :boolean
  )
end

class Comment < ApplicationRecord
  belongs_to :post
end
