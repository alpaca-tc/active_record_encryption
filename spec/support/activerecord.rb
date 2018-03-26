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

Module.new do
  def create_table(table_name, &block)
    around do |example|
      ActiveRecord::Base.connection.create_table(table_name, force: true, &block)
      example.run
    ensure
      ActiveRecord::Base.connection.drop_table(table_name)
    end
  end

  RSpec.configuration.extend(self)
end
