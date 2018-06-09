# frozen_string_literal: true

RSpec.shared_context 'with activerecord model' do
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
      encrypted_attribute(:comments, :string)
      encrypted_attribute(:followers_count, :integer, default: 0)
      encrypted_attribute(:friends_too_count, :integer, default: 0)
      encrypted_attribute(:insures, :integer, default: 0)
      encrypted_attribute(:created_at, :datetime)
      encrypted_attribute(:updated_at, :datetime)
    end

    table do |t|
      t.binary :first_name
      t.binary :gender
      # ActiveRecordEncryption doesn't support optimitic lock
      t.integer :lock_version, default: 0
      t.binary :comments
      t.binary :followers_count
      t.binary :friends_too_count
      t.binary :insures
      t.binary :created_at
      t.binary :updated_at
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

      serialize :content
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
      t.binary :wheels_count
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

      alias_attribute :title, :name

      if ActiveRecord.gem_version >= Gem::Version.create('5.2.0')
        attribute :cancel_save_from_callback
      else
        attr_accessor :cancel_save_from_callback
      end
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
end
