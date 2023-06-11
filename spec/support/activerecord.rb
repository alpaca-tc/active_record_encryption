# frozen_string_literal: true

require 'active_record'

ActiveRecord::Base.establish_connection(adapter: 'sqlite3', database: ':memory:')

class Sqlite3Adapter < ActiveRecord::Base
  self.abstract_class = true

  establish_connection(adapter: 'sqlite3', database: ':memory:')
end

class Mysql2Adapter < ActiveRecord::Base
  self.abstract_class = true

  CONFIGURATION = {
    adapter: 'mysql2',
    database: ENV.fetch('ACTIVERECORD_ENCRYPTION_DBNAME', 'active_record_encryption'),
    username: ENV.fetch('ACTIVERECORD_ENCRYPTION_USERNAME', 'root'),
    password: ENV.fetch('ACTIVERECORD_ENCRYPTION_PASSWORD', ''),
    host: ENV.fetch('ACTIVERECORD_ENCRYPTION_HOST', '127.0.0.1'),
  }.freeze

  establish_connection(CONFIGURATION)

  def self.recreate_database
    establish_connection(configuration_without_database)
    connection.drop_database(CONFIGURATION.fetch(:database))
    connection.create_database(CONFIGURATION.fetch(:database), charset: 'utf8mb4', collation: 'utf8mb4_bin')
    establish_connection(CONFIGURATION)
  end

  def self.configuration_without_database
    CONFIGURATION.merge(database: nil)
  end
end

# Create database at the first
RSpec.configuration.before(:suite) do
  Mysql2Adapter.recreate_database
end
