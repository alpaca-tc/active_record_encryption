ActiveRecord::Base.establish_connection(adapter: 'sqlite3', database: ':memory:')

ActiveRecord::Schema.define do
  create_table(:posts, force: true) do |t|
    t.string :title, null: false
    t.text :body, null: false
    t.string :published_at
    t.timestamps
  end

  create_table(:comments, force: true) do |t|
    t.references :post, null: false
    t.string :rating, null: false
    t.string :body, null: false
    t.timestamps
  end
end
