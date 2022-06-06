# frozen_string_literal: true

require 'active_support/notifications'

module WithTimezoneConfig
  # rubocop:disable Metrics/AbcSize
  def with_timezone_config(cfg)
    old_default_zone = ActiveRecord::Base.default_timezone
    old_awareness = ActiveRecord::Base.time_zone_aware_attributes
    old_zone = Time.zone

    ActiveRecord::Base.default_timezone = cfg[:default] if cfg.key?(:default)
    ActiveRecord::Base.time_zone_aware_attributes = cfg[:aware_attributes] if cfg.key?(:aware_attributes)
    Time.zone = cfg[:zone] if cfg.key?(:zone)
    yield
  ensure
    ActiveRecord::Base.default_timezone = old_default_zone
    ActiveRecord::Base.time_zone_aware_attributes = old_awareness
    Time.zone = old_zone
  end
  # rubocop:enable Metrics/AbcSize
end

module ActiveRecordAssertion
  extend ActiveSupport::Concern

  included do
    before do
      SQLCounter.clear_log
    end

    around do |example|
      Sqlite3Adapter.transaction do
        example.run
      end
    end
  end

  def create_fixtures(*fixture_set_names, &block)
    ActiveRecord::FixtureSet.create_fixtures(ActiveRecord::TestCase.fixture_path, fixture_set_names, fixture_class_names, &block)
  end

  def capture_sql
    SQLCounter.clear_log
    yield
    SQLCounter.log_all.dup
  end

  def assert_sql(*patterns_to_match, &block)
    capture_sql(&block)
  ensure
    failed_patterns = []
    patterns_to_match.each do |pattern|
      failed_patterns << pattern unless SQLCounter.log_all.any? { |sql| pattern =~ sql }
    end
    assert failed_patterns.empty?, "Query pattern(s) #{failed_patterns.map(&:inspect).join(', ')} not found.#{SQLCounter.log.empty? ? '' : "\nQueries:\n#{SQLCounter.log.join("\n")}"}"
  end

  def assert_queries(num = 1, options = {})
    ignore_none = options.fetch(:ignore_none) { num == :any }
    SQLCounter.clear_log
    x = yield
    the_log = ignore_none ? SQLCounter.log_all : SQLCounter.log
    if num == :any
      assert_operator the_log.size, :>=, 1, '1 or more queries expected, but none were executed.'
    else
      mesg = "#{the_log.size} instead of #{num} queries were executed.#{the_log.empty? ? '' : "\nQueries:\n#{the_log.join("\n")}"}"
      assert_equal num, the_log.size, mesg
    end
    x
  end

  def assert_no_queries(options = {}, &block)
    options.reverse_merge! ignore_none: true
    assert_queries(0, options, &block)
  end

  def assert_column(model, column_name, msg = nil)
    assert has_column?(model, column_name), msg
  end

  def assert_no_column(model, column_name, msg = nil)
    assert_not has_column?(model, column_name), msg
  end

  def has_column?(model, column_name)
    model.reset_column_information
    model.column_names.include?(column_name.to_s)
  end
end

class SQLCounter
  class << self
    attr_accessor :ignored_sql, :log, :log_all

    def clear_log
      self.log = []
      self.log_all = []
    end
  end

  clear_log

  self.ignored_sql = [/^PRAGMA/, /^SELECT currval/, /^SELECT CAST/, /^SELECT @@IDENTITY/, /^SELECT @@ROWCOUNT/, /^SAVEPOINT/, /^ROLLBACK TO SAVEPOINT/, /^RELEASE SAVEPOINT/, /^SHOW max_identifier_length/, /^BEGIN/, /^COMMIT/]

  # FIXME: this needs to be refactored so specific database can add their own
  # ignored SQL, or better yet, use a different notification for the queries
  # instead examining the SQL content.
  oracle_ignored     = [/^select .*nextval/i, /^SAVEPOINT/, /^ROLLBACK TO/, /^\s*select .* from all_triggers/im, /^\s*select .* from all_constraints/im, /^\s*select .* from all_tab_cols/im]
  mysql_ignored      = [/^SHOW FULL TABLES/i, /^SHOW FULL FIELDS/, /^SHOW CREATE TABLE /i, /^SHOW VARIABLES /, /^\s*SELECT (?:column_name|table_name)\b.*\bFROM information_schema\.(?:key_column_usage|tables)\b/im]
  postgresql_ignored = [/^\s*select\b.*\bfrom\b.*pg_namespace\b/im, /^\s*select tablename\b.*from pg_tables\b/im, /^\s*select\b.*\battname\b.*\bfrom\b.*\bpg_attribute\b/im, /^SHOW search_path/i]
  sqlite3_ignored =    [/^\s*SELECT name\b.*\bFROM sqlite_master/im, /^\s*SELECT sql\b.*\bFROM sqlite_master/im]

  [oracle_ignored, mysql_ignored, postgresql_ignored, sqlite3_ignored].each do |db_ignored_sql|
    ignored_sql.concat db_ignored_sql
  end

  attr_reader :ignore

  def initialize(ignore = Regexp.union(self.class.ignored_sql))
    @ignore = ignore
  end

  def call(_name, _start, _finish, _message_id, values)
    return if values[:cached]

    sql = values[:sql]
    self.class.log_all << sql
    self.class.log << sql unless ignore =~ sql
  end
end

ActiveSupport::Notifications.subscribe('sql.active_record', SQLCounter.new)
