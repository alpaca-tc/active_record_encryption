# frozen_string_literal: true

RSpec.describe ActiveRecord::AttributeMethods::Dirty do
  describe 'InstanceMethods' do
    stub_model('Pirate') do
      model do
        include(ActiveRecordEncryption::EncryptedAttribute)

        encrypted_attribute(:catchphrase, :string)
        encrypted_attribute(:parrot_id, :integer)
        encrypted_attribute(:non_validated_parrot_id, :integer)
        encrypted_attribute(:created_on, :datetime)
        encrypted_attribute(:updated_on, :datetime)
      end

      table do |t|
        t.binary :catchphrase
        t.binary :parrot_id
        t.binary :non_validated_parrot_id
        t.binary :created_on
        t.binary :updated_on
      end
    end

    stub_model('Person') do
      model do
        include(ActiveRecordEncryption::EncryptedAttribute)

        encrypted_attribute(:first_name, :string)
        encrypted_attribute(:gender, :string)
        encrypted_attribute(:lock_version, :integer, default: 0)
        encrypted_attribute(:comments, :string)
        encrypted_attribute(:followers_count, :integer, default: 0)
        encrypted_attribute(:friends_too_count, :integer, default: 0)
        encrypted_attribute(:insures, :integer, default: 0)
        encrypted_attribute(:created_at, :datetime)
        encrypted_attribute(:updated_at, :datetime)
      end

      table do |t|
        t.binary :first_name, null: false
        t.binary :gender
        t.binary :lock_version, null: false
        t.binary :comments
        t.binary :followers_count
        t.binary :friends_too_count
        t.binary :insures, null: false
        t.binary :created_at, null: false
        t.binary :updated_at, null: false
      end
    end

    stub_model('Topic') do
      model do
        include(ActiveRecordEncryption::EncryptedAttribute)

        encrypted_attribute(:title, :string, limit: 250)
        encrypted_attribute(:author_name, :string)
        encrypted_attribute(:author_email_address, :string)
        encrypted_attribute(:written_on, :datetime)
        encrypted_attribute(:bonus_time, :time)
        encrypted_attribute(:last_read, :date)
        encrypted_attribute(:content, :string)
        encrypted_attribute(:important, :string)
        encrypted_attribute(:approved, :boolean, default: true)
        encrypted_attribute(:replies_count, :integer, default: 0)
        encrypted_attribute(:unique_replies_count, :integer, default: 0)
        encrypted_attribute(:parent_title, :string)
        encrypted_attribute(:type, :string)
        encrypted_attribute(:group, :string)
        encrypted_attribute(:created_at, :datetime)
        encrypted_attribute(:updated_at, :datetime)
      end

      table do |t|
        t.binary :title
        t.binary :author_name
        t.binary :author_email_address
        t.binary :written_on
        t.binary :bonus_time
        t.binary :last_read
        t.binary :content
        t.binary :important
        t.binary :approved
        t.binary :replies_count
        t.binary :unique_replies_count
        t.binary :parent_title
        t.binary :type
        t.binary :group
        t.binary :created_at
        t.binary :updated_at
      end
    end

    stub_model('Aircraft') do
      model do
        include(ActiveRecordEncryption::EncryptedAttribute)

        encrypted_attribute(:name, :string)
        encrypted_attribute(:wheels_count, :integer, default: 0)
      end

      table do |t|
        t.binary :name
        t.binary :wheels_count, null: false
      end
    end

    stub_model('Parrot') do
      model do
        include(ActiveRecordEncryption::EncryptedAttribute)

        encrypted_attribute(:name, :string)
        encrypted_attribute(:color, :string)
        encrypted_attribute(:parrot_sti_class, :string)
        encrypted_attribute(:killer_id, :integer)
        encrypted_attribute(:updated_count, :integer, default: 0)
        encrypted_attribute(:created_at, :datetime)
        encrypted_attribute(:created_on, :datetime)
        encrypted_attribute(:updated_at, :datetime)
        encrypted_attribute(:updated_on, :datetime)
      end

      table do |t|
        t.binary :name
        t.binary :color
        t.binary :parrot_sti_class
        t.binary :killer_id
        t.binary :updated_count
        t.binary :created_at
        t.binary :created_on
        t.binary :updated_at
        t.binary :updated_on
      end
    end

    stub_model('NumericData') do
      model do
        include(ActiveRecordEncryption::EncryptedAttribute)

        encrypted_attribute(:bank_balance, :decimal, precision: 10, scale: 2)
        encrypted_attribute(:big_bank_balance, :decimal, precision: 15, scale: 2)
        encrypted_attribute(:world_population, :decimal, precision: 20, scale: 0)
        encrypted_attribute(:my_house_population, :decimal, precision: 2, scale: 0)
        encrypted_attribute(:decimal_number_with_default, :decimal, precision: 3, scale: 2, default: 2.78)
        encrypted_attribute(:temperature, :float)
        encrypted_attribute(:atoms_in_universe, :decimal, precision: 55, scale: 0)
      end

      table do |t|
        t.binary :bank_balance
        t.binary :big_bank_balance
        t.binary :world_population
        t.binary :my_house_population
        t.binary :decimal_number_with_default
        t.binary :temperature
        t.binary :atoms_in_universe
      end
    end

    stub_model('Binary') do
      model do
        include(ActiveRecordEncryption::EncryptedAttribute)

        encrypted_attribute(:name, :string)
        encrypted_attribute(:data, :binary)
        encrypted_attribute(:short_data, :binary, limit: 2048)
      end

      table do |t|
        t.binary :name
        t.binary :data
        t.binary :short_data
      end
    end

    before do
      # Stub connection of base class
      allow(ActiveRecord::Base).to receive(:connection).and_return(Sqlite3Adapter.connection)
    end

    # Copy from rails/rails 'activerecord/test/cases/dirty_test.rb'
    # Replace `def xxx` with `example 'xxx' do`
    #   Call `:%s!def \(.*\)!example '\1' do!g`
    #   Call `:%s!test '\(.*\)' do!example '\1' do!g`
    #   Call `:%s!test "\(.*\)" do!example "\1" do!g`
    describe 'Copy from rails' do
      # FIXME: I think that this way is not best.
      module ActiveSupportTestCaseCompatible
        extend ActiveSupport::Concern

        included do
          # test/unit backwards compatibility methods
          alias_method :assert_raise, :assert_raises
          alias_method :assert_not_empty, :refute_empty
          alias_method :assert_not_equal, :refute_equal
          alias_method :assert_not_in_delta, :refute_in_delta
          alias_method :assert_not_in_epsilon, :refute_in_epsilon
          alias_method :assert_not_includes, :refute_includes
          alias_method :assert_not_instance_of, :refute_instance_of
          alias_method :assert_not_kind_of, :refute_kind_of
          alias_method :assert_no_match, :refute_match
          alias_method :assert_not_nil, :refute_nil
          alias_method :assert_not_operator, :refute_operator
          alias_method :assert_not_predicate, :refute_predicate
          alias_method :assert_not_respond_to, :refute_respond_to
          alias_method :assert_not_same, :refute_same
        end

        private

        def with_timezone_config(cfg)
          old_default_zone = ActiveRecord::Base.default_timezone
          old_awareness = ActiveRecord::Base.time_zone_aware_attributes
          old_zone = Time.zone

          if cfg.key?(:default)
            ActiveRecord::Base.default_timezone = cfg[:default]
          end
          if cfg.key?(:aware_attributes)
            ActiveRecord::Base.time_zone_aware_attributes = cfg[:aware_attributes]
          end
          Time.zone = cfg[:zone] if cfg.key?(:zone)
          yield
        ensure
          ActiveRecord::Base.default_timezone = old_default_zone
          ActiveRecord::Base.time_zone_aware_attributes = old_awareness
          Time.zone = old_zone
        end

        def in_time_zone(zone)
          old_zone  = Time.zone
          old_tz    = ActiveRecord::Base.time_zone_aware_attributes

          Time.zone = zone ? ActiveSupport::TimeZone[zone] : nil
          ActiveRecord::Base.time_zone_aware_attributes = !zone.nil?
          yield
        ensure
          Time.zone = old_zone
          ActiveRecord::Base.time_zone_aware_attributes = old_tz
        end
      end

      require 'active_support/test_case'
      include ActiveSupport::Testing::Assertions
      include ActiveSupportTestCaseCompatible

      example 'test_attribute_changes' do
        # New record - no changes.
        pirate = Pirate.new
        assert_equal false, pirate.catchphrase_changed?
        assert_equal false, pirate.non_validated_parrot_id_changed?

        # Change catchphrase.
        pirate.catchphrase = 'arrr'
        assert_predicate pirate, :catchphrase_changed?
        assert_nil pirate.catchphrase_was
        assert_equal [nil, 'arrr'], pirate.catchphrase_change

        # Saved - no changes.
        pirate.save!
        assert_not_predicate pirate, :catchphrase_changed?
        assert_nil pirate.catchphrase_change

        # Same value - no changes.
        pirate.catchphrase = 'arrr'
        assert_not_predicate pirate, :catchphrase_changed?
        assert_nil pirate.catchphrase_change
      end

      example 'test_time_attributes_changes_with_time_zone' do
        in_time_zone 'Paris' do
          target = Class.new(ActiveRecord::Base)
          target.table_name = 'pirates'

          # New record - no changes.
          pirate = target.new
          assert_not_predicate pirate, :created_on_changed?
          assert_nil pirate.created_on_change

          # Saved - no changes.
          pirate.catchphrase = 'arrrr, time zone!!'
          pirate.save!
          assert_not_predicate pirate, :created_on_changed?
          assert_nil pirate.created_on_change

          # Change created_on.
          old_created_on = pirate.created_on
          pirate.created_on = Time.now - 1.day
          assert_predicate pirate, :created_on_changed?
          assert_kind_of ActiveSupport::TimeWithZone, pirate.created_on_was
          assert_equal old_created_on, pirate.created_on_was
          pirate.created_on = old_created_on
          assert_not_predicate pirate, :created_on_changed?
        end
      end

      example 'test_setting_time_attributes_with_time_zone_field_to_itself_should_not_be_marked_as_a_change' do
        in_time_zone 'Paris' do
          target = Class.new(ActiveRecord::Base)
          target.table_name = 'pirates'

          pirate = target.create!
          pirate.created_on = pirate.created_on
          assert_not_predicate pirate, :created_on_changed?
        end
      end

      example 'test_time_attributes_changes_without_time_zone_by_skip' do
        in_time_zone 'Paris' do
          target = Class.new(ActiveRecord::Base)
          target.table_name = 'pirates'

          target.skip_time_zone_conversion_for_attributes = [:created_on]

          # New record - no changes.
          pirate = target.new
          assert_not_predicate pirate, :created_on_changed?
          assert_nil pirate.created_on_change

          # Saved - no changes.
          pirate.catchphrase = 'arrrr, time zone!!'
          pirate.save!
          assert_not_predicate pirate, :created_on_changed?
          assert_nil pirate.created_on_change

          # Change created_on.
          old_created_on = pirate.created_on
          pirate.created_on = Time.now + 1.day
          assert_predicate pirate, :created_on_changed?
          # kind_of does not work because
          # ActiveSupport::TimeWithZone.name == 'Time'
          assert_instance_of Time, pirate.created_on_was
          assert_equal old_created_on, pirate.created_on_was
        end
      end

      example 'test_time_attributes_changes_without_time_zone' do
        with_timezone_config aware_attributes: false do
          target = Class.new(ActiveRecord::Base)
          target.table_name = 'pirates'

          # New record - no changes.
          pirate = target.new
          assert_not_predicate pirate, :created_on_changed?
          assert_nil pirate.created_on_change

          # Saved - no changes.
          pirate.catchphrase = 'arrrr, time zone!!'
          pirate.save!
          assert_not_predicate pirate, :created_on_changed?
          assert_nil pirate.created_on_change

          # Change created_on.
          old_created_on = pirate.created_on
          pirate.created_on = Time.now + 1.day
          assert_predicate pirate, :created_on_changed?
          # kind_of does not work because
          # ActiveSupport::TimeWithZone.name == 'Time'
          assert_instance_of Time, pirate.created_on_was
          assert_equal old_created_on, pirate.created_on_was
        end
      end

      example 'test_aliased_attribute_changes' do
        # the actual attribute here is name, title is an
        # alias setup via alias_attribute
        parrot = Parrot.new
        assert_not_predicate parrot, :title_changed?
        assert_nil parrot.title_change

        parrot.name = 'Sam'
        assert_predicate parrot, :title_changed?
        assert_nil parrot.title_was
        assert_equal parrot.name_change, parrot.title_change
      end

      example 'test_restore_attribute!' do
        pirate = Pirate.create!(catchphrase: 'Yar!')
        pirate.catchphrase = 'Ahoy!'

        pirate.restore_catchphrase!
        assert_equal 'Yar!', pirate.catchphrase
        assert_equal({}, pirate.changes)
        assert_not_predicate pirate, :catchphrase_changed?
      end

      example 'test_nullable_number_not_marked_as_changed_if_new_value_is_blank' do
        pirate = Pirate.new

        ['', nil].each do |value|
          pirate.parrot_id = value
          assert_not_predicate pirate, :parrot_id_changed?
          assert_nil pirate.parrot_id_change
        end
      end

      example 'test_nullable_decimal_not_marked_as_changed_if_new_value_is_blank' do
        numeric_data = NumericData.new

        ['', nil].each do |value|
          numeric_data.bank_balance = value
          assert_not_predicate numeric_data, :bank_balance_changed?
          assert_nil numeric_data.bank_balance_change
        end
      end

      example 'test_nullable_float_not_marked_as_changed_if_new_value_is_blank' do
        numeric_data = NumericData.new

        ['', nil].each do |value|
          numeric_data.temperature = value
          assert_not_predicate numeric_data, :temperature_changed?
          assert_nil numeric_data.temperature_change
        end
      end

      example 'test_nullable_datetime_not_marked_as_changed_if_new_value_is_blank' do
        in_time_zone 'Edinburgh' do
          target = Class.new(ActiveRecord::Base)
          target.table_name = 'topics'

          topic = target.create
          assert_nil topic.written_on

          ['', nil].each do |value|
            topic.written_on = value
            assert_nil topic.written_on
            assert_not_predicate topic, :written_on_changed?
          end
        end
      end

      example 'test_integer_zero_to_string_zero_not_marked_as_changed' do
        pirate = Pirate.new
        pirate.parrot_id = 0
        pirate.catchphrase = 'arrr'
        assert pirate.save!

        assert_not_predicate pirate, :changed?

        pirate.parrot_id = '0'
        assert_not_predicate pirate, :changed?
      end

      example 'test_integer_zero_to_integer_zero_not_marked_as_changed' do
        pirate = Pirate.new
        pirate.parrot_id = 0
        pirate.catchphrase = 'arrr'
        assert pirate.save!

        assert_not_predicate pirate, :changed?

        pirate.parrot_id = 0
        assert_not_predicate pirate, :changed?
      end

      example 'test_float_zero_to_string_zero_not_marked_as_changed' do
        data = NumericData.new temperature: 0.0
        data.save!

        assert_not_predicate data, :changed?

        data.temperature = '0'
        assert_empty data.changes

        data.temperature = '0.0'
        assert_empty data.changes

        data.temperature = '0.00'
        assert_empty data.changes
      end

      example 'test_zero_to_blank_marked_as_changed' do
        pirate = Pirate.new
        pirate.catchphrase = 'Yarrrr, me hearties'
        pirate.parrot_id = 1
        pirate.save

        # check the change from 1 to ''
        pirate = Pirate.find_by_catchphrase('Yarrrr, me hearties')
        pirate.parrot_id = ''
        assert_predicate pirate, :parrot_id_changed?
        assert_equal([1, nil], pirate.parrot_id_change)
        pirate.save

        # check the change from nil to 0
        pirate = Pirate.find_by_catchphrase('Yarrrr, me hearties')
        pirate.parrot_id = 0
        assert_predicate pirate, :parrot_id_changed?
        assert_equal([nil, 0], pirate.parrot_id_change)
        pirate.save

        # check the change from 0 to ''
        pirate = Pirate.find_by_catchphrase('Yarrrr, me hearties')
        pirate.parrot_id = ''
        assert_predicate pirate, :parrot_id_changed?
        assert_equal([0, nil], pirate.parrot_id_change)
      end

      example 'test_object_should_be_changed_if_any_attribute_is_changed' do
        pirate = Pirate.new
        assert_not_predicate pirate, :changed?
        assert_equal [], pirate.changed
        assert_equal({}, pirate.changes)

        pirate.catchphrase = 'arrr'
        assert_predicate pirate, :changed?
        assert_nil pirate.catchphrase_was
        assert_equal %w[catchphrase], pirate.changed
        assert_equal({ 'catchphrase' => [nil, 'arrr'] }, pirate.changes)

        pirate.save
        assert_not_predicate pirate, :changed?
        assert_equal [], pirate.changed
        assert_equal({}, pirate.changes)
      end

      example 'test_attribute_will_change!' do
        pirate = Pirate.create!(catchphrase: 'arr')

        assert_not_predicate pirate, :catchphrase_changed?
        assert pirate.catchphrase_will_change!
        assert_predicate pirate, :catchphrase_changed?
        assert_equal %w[arr arr], pirate.catchphrase_change

        pirate.catchphrase << ' matey!'
        assert_predicate pirate, :catchphrase_changed?
        assert_equal ['arr', 'arr matey!'], pirate.catchphrase_change
      end

      example 'test_virtual_attribute_will_change' do
        parrot = Parrot.create!(name: 'Ruby')
        parrot.send(:attribute_will_change!, :cancel_save_from_callback)
        assert_predicate parrot, :has_changes_to_save?
      end

      example 'test_association_assignment_changes_foreign_key' do
        pirate = Pirate.create!(catchphrase: 'jarl')
        pirate.parrot = Parrot.create!(name: 'Lorre')
        assert_predicate pirate, :changed?
        assert_equal %w[parrot_id], pirate.changed
      end

      example 'test_attribute_should_be_compared_with_type_cast' do
        topic = Topic.new
        assert_predicate topic, :approved?
        assert_not_predicate topic, :approved_changed?

        # Coming from web form.
        params = { topic: { approved: 1 } }
        # In the controller.
        topic.attributes = params[:topic]
        assert_predicate topic, :approved?
        assert_not_predicate topic, :approved_changed?
      end

      example 'test_partial_update' do
        pirate = Pirate.new(catchphrase: 'foo')
        old_updated_on = 1.hour.ago.beginning_of_day

        with_partial_writes Pirate, false do
          assert_queries(2) { 2.times { pirate.save! } }
          Pirate.where(id: pirate.id).update_all(updated_on: old_updated_on)
        end

        with_partial_writes Pirate, true do
          assert_queries(0) { 2.times { pirate.save! } }
          assert_equal old_updated_on, pirate.reload.updated_on

          assert_queries(1) {
            pirate.catchphrase = 'bar'
            pirate.save!
          }
          assert_not_equal old_updated_on, pirate.reload.updated_on
        end
      end

      example 'test_partial_update_with_optimistic_locking' do
        person = Person.new(first_name: 'foo')

        with_partial_writes Person, false do
          assert_queries(2) { 2.times { person.save! } }
          Person.where(id: person.id).update_all(first_name: 'baz')
        end

        old_lock_version = person.lock_version

        with_partial_writes Person, true do
          assert_queries(0) {
            2.times {
              person.save!
            }
          }
          assert_equal old_lock_version, person.reload.lock_version

          assert_queries(1) {
            person.first_name = 'bar'
            person.save!
          }
          assert_not_equal old_lock_version, person.reload.lock_version
        end
      end

      example 'test_changed_attributes_should_be_preserved_if_save_failure' do
        pirate = Pirate.new
        pirate.parrot_id = 1
        assert_not pirate.save
        check_pirate_after_save_failure(pirate)

        pirate = Pirate.new
        pirate.parrot_id = 1
        assert_raise(ActiveRecord::RecordInvalid) { pirate.save! }
        check_pirate_after_save_failure(pirate)
      end

      example 'test_reload_should_clear_changed_attributes' do
        pirate = Pirate.create!(catchphrase: 'shiver me timbers')
        pirate.catchphrase = '*hic*'
        assert_predicate pirate, :changed?
        pirate.reload
        assert_not_predicate pirate, :changed?
      end

      example 'test_dup_objects_should_not_copy_dirty_flag_from_creator' do
        pirate = Pirate.create!(catchphrase: 'shiver me timbers')
        pirate_dup = pirate.dup
        pirate_dup.restore_catchphrase!
        pirate.catchphrase = 'I love Rum'
        assert_predicate pirate, :catchphrase_changed?
        assert_not_predicate pirate_dup, :catchphrase_changed?
      end

      example 'test_reverted_changes_are_not_dirty' do
        phrase = 'shiver me timbers'
        pirate = Pirate.create!(catchphrase: phrase)
        pirate.catchphrase = '*hic*'
        assert_predicate pirate, :changed?
        pirate.catchphrase = phrase
        assert_not_predicate pirate, :changed?
      end

      example 'test_reverted_changes_are_not_dirty_after_multiple_changes' do
        phrase = 'shiver me timbers'
        pirate = Pirate.create!(catchphrase: phrase)
        10.times do |i|
          pirate.catchphrase = '*hic*' * i
          assert_predicate pirate, :changed?
        end
        assert_predicate pirate, :changed?
        pirate.catchphrase = phrase
        assert_not_predicate pirate, :changed?
      end

      example 'test_reverted_changes_are_not_dirty_going_from_nil_to_value_and_back' do
        pirate = Pirate.create!(catchphrase: 'Yar!')

        pirate.parrot_id = 1
        assert_predicate pirate, :changed?
        assert_predicate pirate, :parrot_id_changed?
        assert_not_predicate pirate, :catchphrase_changed?

        pirate.parrot_id = nil
        assert_not_predicate pirate, :changed?
        assert_not_predicate pirate, :parrot_id_changed?
        assert_not_predicate pirate, :catchphrase_changed?
      end

      example 'test_save_should_store_serialized_attributes_even_with_partial_writes' do
        with_partial_writes(Topic) do
          topic = Topic.create!(content: { a: 'a' })

          assert_not_predicate topic, :changed?

          topic.content[:b] = 'b'

          assert_predicate topic, :changed?

          topic.save!

          assert_not_predicate topic, :changed?
          assert_equal 'b', topic.content[:b]

          topic.reload

          assert_equal 'b', topic.content[:b]
        end
      end

      example 'test_save_always_should_update_timestamps_when_serialized_attributes_are_present' do
        with_partial_writes(Topic) do
          topic = Topic.create!(content: { a: 'a' })
          topic.save!

          updated_at = topic.updated_at
          travel(1.second) do
            topic.content[:hello] = 'world'
            topic.save!
          end

          assert_not_equal updated_at, topic.updated_at
          assert_equal 'world', topic.content[:hello]
        end
      end

      example 'test_save_should_not_save_serialized_attribute_with_partial_writes_if_not_present' do
        with_partial_writes(Topic) do
          topic = Topic.create!(author_name: 'Bill', content: { a: 'a' })
          topic = Topic.select('id, author_name').find(topic.id)
          topic.update_columns author_name: 'John'
          assert_not_nil topic.reload.content
        end
      end

      example 'test_changes_to_save_should_not_mutate_array_of_hashes' do
        topic = Topic.new(author_name: 'Bill', content: [{ a: 'a' }])

        topic.changes_to_save

        assert_equal [{ a: 'a' }], topic.content
      end

      example 'test_previous_changes' do
        # original values should be in previous_changes
        pirate = Pirate.new

        assert_equal({}, pirate.previous_changes)
        pirate.catchphrase = 'arrr'
        pirate.save!

        assert_equal 4, pirate.previous_changes.size
        assert_equal [nil, 'arrr'], pirate.previous_changes['catchphrase']
        assert_equal [nil, pirate.id], pirate.previous_changes['id']
        assert_nil pirate.previous_changes['updated_on'][0]
        assert_not_nil pirate.previous_changes['updated_on'][1]
        assert_nil pirate.previous_changes['created_on'][0]
        assert_not_nil pirate.previous_changes['created_on'][1]
        assert_not pirate.previous_changes.key?('parrot_id')

        # original values should be in previous_changes
        pirate = Pirate.new

        assert_equal({}, pirate.previous_changes)
        pirate.catchphrase = 'arrr'
        pirate.save

        assert_equal 4, pirate.previous_changes.size
        assert_equal [nil, 'arrr'], pirate.previous_changes['catchphrase']
        assert_equal [nil, pirate.id], pirate.previous_changes['id']
        assert_includes pirate.previous_changes, 'updated_on'
        assert_includes pirate.previous_changes, 'created_on'
        assert_not pirate.previous_changes.key?('parrot_id')

        pirate.catchphrase = 'Yar!!'
        pirate.reload
        assert_equal({}, pirate.previous_changes)

        pirate = Pirate.find_by_catchphrase('arrr')

        travel(1.second)

        pirate.catchphrase = 'Me Maties!'
        pirate.save!

        assert_equal 2, pirate.previous_changes.size
        assert_equal ['arrr', 'Me Maties!'], pirate.previous_changes['catchphrase']
        assert_not_nil pirate.previous_changes['updated_on'][0]
        assert_not_nil pirate.previous_changes['updated_on'][1]
        assert_not pirate.previous_changes.key?('parrot_id')
        assert_not pirate.previous_changes.key?('created_on')

        pirate = Pirate.find_by_catchphrase('Me Maties!')

        travel(1.second)

        pirate.catchphrase = 'Thar She Blows!'
        pirate.save

        assert_equal 2, pirate.previous_changes.size
        assert_equal ['Me Maties!', 'Thar She Blows!'], pirate.previous_changes['catchphrase']
        assert_not_nil pirate.previous_changes['updated_on'][0]
        assert_not_nil pirate.previous_changes['updated_on'][1]
        assert_not pirate.previous_changes.key?('parrot_id')
        assert_not pirate.previous_changes.key?('created_on')

        travel(1.second)

        pirate = Pirate.find_by_catchphrase('Thar She Blows!')
        pirate.update(catchphrase: 'Ahoy!')

        assert_equal 2, pirate.previous_changes.size
        assert_equal ['Thar She Blows!', 'Ahoy!'], pirate.previous_changes['catchphrase']
        assert_not_nil pirate.previous_changes['updated_on'][0]
        assert_not_nil pirate.previous_changes['updated_on'][1]
        assert_not pirate.previous_changes.key?('parrot_id')
        assert_not pirate.previous_changes.key?('created_on')

        travel(1.second)

        pirate = Pirate.find_by_catchphrase('Ahoy!')
        pirate.update_attribute(:catchphrase, 'Ninjas suck!')

        assert_equal 2, pirate.previous_changes.size
        assert_equal ['Ahoy!', 'Ninjas suck!'], pirate.previous_changes['catchphrase']
        assert_not_nil pirate.previous_changes['updated_on'][0]
        assert_not_nil pirate.previous_changes['updated_on'][1]
        assert_not pirate.previous_changes.key?('parrot_id')
        assert_not pirate.previous_changes.key?('created_on')
      ensure
        travel_back
      end

      class Testings < ActiveRecord::Base; end
      example 'test_field_named_field' do
        ActiveRecord::Base.connection.create_table :testings do |t|
          t.string :field
        end
        assert_nothing_raised do
          Testings.new.attributes
        end
      ensure
        begin
          ActiveRecord::Base.connection.drop_table :testings
        rescue StandardError
          nil
        end
        ActiveRecord::Base.clear_cache!
      end

      example 'test_datetime_attribute_can_be_updated_with_fractional_seconds' do
        skip 'Fractional seconds are not supported' unless subsecond_precision_supported?
        in_time_zone 'Paris' do
          target = Class.new(ActiveRecord::Base)
          target.table_name = 'topics'

          written_on = Time.utc(2012, 12, 1, 12, 0, 0).in_time_zone('Paris')

          topic = target.create(written_on: written_on)
          topic.written_on += 0.3

          assert topic.written_on_changed?, 'Fractional second update not detected'
        end
      end

      example 'test_datetime_attribute_doesnt_change_if_zone_is_modified_in_string' do
        time_in_paris = Time.utc(2014, 1, 1, 12, 0, 0).in_time_zone('Paris')
        pirate = Pirate.create!(catchphrase: 'rrrr', created_on: time_in_paris)

        pirate.created_on = pirate.created_on.in_time_zone('Tokyo').to_s
        assert_not_predicate pirate, :created_on_changed?
      end

      example 'partial insert' do
        with_partial_writes Person do
          jon = nil
          assert_sql(/first_name/i) do
            jon = Person.create! first_name: 'Jon'
          end

          assert ActiveRecord::SQLCounter.log_all.none? { |sql| sql.include?('followers_count') }

          jon.reload
          assert_equal 'Jon', jon.first_name
          assert_equal 0, jon.followers_count
          assert_not_nil jon.id
        end
      end

      example 'partial insert with empty values' do
        with_partial_writes Aircraft do
          a = Aircraft.create!
          a.reload
          assert_not_nil a.id
        end
      end

      example 'in place mutation detection' do
        pirate = Pirate.create!(catchphrase: 'arrrr')
        pirate.catchphrase << ' matey!'

        assert_predicate pirate, :catchphrase_changed?
        expected_changes = {
          'catchphrase' => ['arrrr', 'arrrr matey!']
        }
        assert_equal(expected_changes, pirate.changes)
        assert_equal('arrrr', pirate.catchphrase_was)
        assert pirate.catchphrase_changed?(from: 'arrrr')
        assert_not pirate.catchphrase_changed?(from: 'anything else')
        assert_includes pirate.changed_attributes, :catchphrase

        pirate.save!
        pirate.reload

        assert_equal 'arrrr matey!', pirate.catchphrase
        assert_not_predicate pirate, :changed?
      end

      example 'in place mutation for binary' do
        klass = Class.new(ActiveRecord::Base) do
          self.table_name = :binaries
          serialize :data
        end

        binary = klass.create!(data: '\\\\foo')

        assert_not_predicate binary, :changed?

        binary.data = binary.data.dup

        assert_not_predicate binary, :changed?

        binary = klass.last

        assert_not_predicate binary, :changed?

        binary.data << 'bar'

        assert_predicate binary, :changed?
      end

      example 'changes is correct for subclass' do
        foo = Class.new(Pirate) do
          def catchphrase
            super.upcase
          end
        end

        pirate = foo.create!(catchphrase: 'arrrr')

        new_catchphrase = 'arrrr matey!'

        pirate.catchphrase = new_catchphrase
        assert_predicate pirate, :catchphrase_changed?

        expected_changes = {
          'catchphrase' => ['arrrr', new_catchphrase]
        }

        assert_equal new_catchphrase.upcase, pirate.catchphrase
        assert_equal expected_changes, pirate.changes
      end

      example 'changes is correct if override attribute reader' do
        pirate = Pirate.create!(catchphrase: 'arrrr')
        def pirate.catchphrase
          super.upcase
        end

        new_catchphrase = 'arrrr matey!'

        pirate.catchphrase = new_catchphrase
        assert_predicate pirate, :catchphrase_changed?

        expected_changes = {
          'catchphrase' => ['arrrr', new_catchphrase]
        }

        assert_equal new_catchphrase.upcase, pirate.catchphrase
        assert_equal expected_changes, pirate.changes
      end

      example "attribute_changed? doesn't compute in-place changes for unrelated attributes" do
        test_type_class = Class.new(ActiveRecord::Type::Value) do
          define_method(:changed_in_place?) do |*|
            raise
          end
        end
        klass = Class.new(ActiveRecord::Base) do
          self.table_name = 'people'
          attribute :foo, test_type_class.new
        end

        model = klass.new(first_name: 'Jim')
        assert_predicate model, :first_name_changed?
      end

      example "attribute_will_change! doesn't try to save non-persistable attributes" do
        klass = Class.new(ActiveRecord::Base) do
          self.table_name = 'people'
          attribute :non_persisted_attribute, :string
        end

        record = klass.new(first_name: 'Sean')
        record.non_persisted_attribute_will_change!

        assert_predicate record, :non_persisted_attribute_changed?
        assert record.save
      end

      example 'virtual attributes are not written with partial_writes off' do
        with_partial_writes(ActiveRecord::Base, false) do
          klass = Class.new(ActiveRecord::Base) do
            self.table_name = 'people'
            attribute :non_persisted_attribute, :string
          end

          record = klass.new(first_name: 'Sean')
          record.non_persisted_attribute_will_change!

          assert record.save

          record.non_persisted_attribute_will_change!

          assert record.save
        end
      end

      example "mutating and then assigning doesn't remove the change" do
        pirate = Pirate.create!(catchphrase: 'arrrr')
        pirate.catchphrase << ' matey!'
        pirate.catchphrase = 'arrrr matey!'

        assert pirate.catchphrase_changed?(from: 'arrrr', to: 'arrrr matey!')
      end

      example 'getters with side effects are allowed' do
        klass = Class.new(Pirate) do
          def catchphrase
            if super.blank?
              update_attribute(:catchphrase, 'arr') # what could possibly go wrong?
            end
            super
          end
        end

        pirate = klass.create!(catchphrase: 'lol')
        pirate.update_attribute(:catchphrase, nil)

        assert_equal 'arr', pirate.catchphrase
      end

      example 'attributes assigned but not selected are dirty' do
        person = Person.select(:id).first
        assert_not_predicate person, :changed?

        person.first_name = 'Sean'
        assert_predicate person, :changed?

        person.first_name = nil
        assert_predicate person, :changed?
      end

      example 'attributes not selected are still missing after save' do
        person = Person.select(:id).first
        assert_raises(ActiveModel::MissingAttributeError) { person.first_name }
        assert person.save # calls forget_attribute_assignments
        assert_raises(ActiveModel::MissingAttributeError) { person.first_name }
      end

      example 'saved_change_to_attribute? returns whether a change occurred in the last save' do
        person = Person.create!(first_name: 'Sean')

        assert_predicate person, :saved_change_to_first_name?
        assert_not_predicate person, :saved_change_to_gender?
        assert person.saved_change_to_first_name?(from: nil, to: 'Sean')
        assert person.saved_change_to_first_name?(from: nil)
        assert person.saved_change_to_first_name?(to: 'Sean')
        assert_not person.saved_change_to_first_name?(from: 'Jim', to: 'Sean')
        assert_not person.saved_change_to_first_name?(from: 'Jim')
        assert_not person.saved_change_to_first_name?(to: 'Jim')
      end

      example 'saved_change_to_attribute returns the change that occurred in the last save' do
        person = Person.create!(first_name: 'Sean', gender: 'M')

        assert_equal [nil, 'Sean'], person.saved_change_to_first_name
        assert_equal [nil, 'M'], person.saved_change_to_gender

        person.update(first_name: 'Jim')

        assert_equal %w[Sean Jim], person.saved_change_to_first_name
        assert_nil person.saved_change_to_gender
      end

      example 'attribute_before_last_save returns the original value before saving' do
        person = Person.create!(first_name: 'Sean', gender: 'M')

        assert_nil person.first_name_before_last_save
        assert_nil person.gender_before_last_save

        person.first_name = 'Jim'

        assert_nil person.first_name_before_last_save
        assert_nil person.gender_before_last_save

        person.save

        assert_equal 'Sean', person.first_name_before_last_save
        assert_equal 'M', person.gender_before_last_save
      end

      example 'saved_changes? returns whether the last call to save changed anything' do
        person = Person.create!(first_name: 'Sean')

        assert_predicate person, :saved_changes?

        person.save

        assert_not_predicate person, :saved_changes?
      end

      example 'saved_changes returns a hash of all the changes that occurred' do
        person = Person.create!(first_name: 'Sean', gender: 'M')

        assert_equal [nil, 'Sean'], person.saved_changes[:first_name]
        assert_equal [nil, 'M'], person.saved_changes[:gender]
        assert_equal %w[id first_name gender created_at updated_at].sort, person.saved_changes.keys.sort

        travel(1.second) do
          person.update(first_name: 'Jim')
        end

        assert_equal %w[Sean Jim], person.saved_changes[:first_name]
        assert_equal %w[first_name lock_version updated_at].sort, person.saved_changes.keys.sort
      end

      example 'changed? in after callbacks returns false' do
        klass = Class.new(ActiveRecord::Base) do
          self.table_name = 'people'

          after_save do
            raise 'changed? should be false' if changed?
            raise 'has_changes_to_save? should be false' if has_changes_to_save?
            raise 'saved_changes? should be true' unless saved_changes?
          end
        end

        person = klass.create!(first_name: 'Sean')
        assert_not_predicate person, :changed?
      end

      private

      def with_partial_writes(klass, on = true)
        old = klass.partial_writes?
        klass.partial_writes = on
        yield
      ensure
        klass.partial_writes = old
      end

      def check_pirate_after_save_failure(pirate)
        assert_predicate pirate, :changed?
        assert_predicate pirate, :parrot_id_changed?
        assert_equal %w[parrot_id], pirate.changed
        assert_nil pirate.parrot_id_was
      end
    end
  end
end
