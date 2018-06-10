# frozen_string_literal: true

RSpec.describe ActiveRecordEncryption::Type do
  describe '#initialize' do
    context 'given no arguments' do
      it 'builds from default options' do
        instance = described_class.new
        expect(instance.send(:encryptor)).to be_a(ActiveRecordEncryption::Encryptor::Raw)
        expect(instance.send(:subtype)).to eq(ActiveRecord::Type::Value.new)
      end
    end

    context 'given symbol as subtype' do
      it 'builds from default options' do
        instance = described_class.new(subtype: :integer)
        expect(instance.send(:subtype)).to eq(ActiveRecord::Type.lookup(:integer))
      end
    end

    context 'given hash as encryption' do
      it 'builds from default options' do
        instance = described_class.new(encryption: { encryptor: :active_support, key: 'key', salt: 'salt' })
        expect(instance.send(:encryptor)).to be_a(ActiveRecordEncryption::Encryptor::ActiveSupport)
      end
    end

    context 'given class as encryption' do
      it 'builds from default options' do
        instance = described_class.new(encryption: { encryptor: ActiveRecordEncryption::Encryptor::ActiveSupport, key: 'key', salt: 'salt' })
        expect(instance.send(:encryptor)).to be_a(ActiveRecordEncryption::Encryptor::ActiveSupport)
      end
    end

    context 'given instance of class as encryption' do
      it 'builds from default options' do
        encryptor = ActiveRecordEncryption::Encryptor::ActiveSupport.new(key: 'key', salt: 'salt')
        instance = described_class.new(encryption: { encryptor: encryptor })
        expect(instance.send(:encryptor)).to eq(encryptor)
      end
    end
  end

  describe '#type' do
    subject { instance.type }
    let(:instance) { described_class.new(subtype: :integer) }
    it { is_expected.to eq(:integer) }
  end

  describe '#cast' do
    subject { instance.cast(value) }

    let(:instance) { described_class.new(subtype: subtype) }

    context 'when subtype is integer' do
      let(:subtype) { :integer }

      context 'given 1' do
        let(:value) { 1 }
        it { is_expected.to eq(1) }
      end

      context 'given "1"' do
        let(:value) { '1' }
        it { is_expected.to eq(1) }
      end
    end

    context 'when subtype is datetime' do
      let(:subtype) { :datetime }

      context 'given "2018-01-01"' do
        let(:value) { '2018-01-01' }
        it { is_expected.to eq(Time.utc(2018, 1, 1).utc) }
      end

      context 'given ""' do
        let(:value) { '' }
        it { is_expected.to be_nil }
      end
    end
  end

  describe '#deserialize' do
    subject { instance.deserialize(value) }

    let(:instance) { described_class.new(subtype: subtype) }

    context 'when subtype is integer' do
      let(:subtype) { :integer }

      context 'given "1"' do
        let(:value) { '1' }
        it { is_expected.to eq(1) }
      end
    end
  end

  describe '#serialize' do
    subject { instance.serialize(value) }

    let(:instance) { described_class.new(subtype: subtype_instance) }
    let(:subtype_instance) { ActiveRecord::Type.lookup(subtype) }

    context 'when subtype is datetime' do
      let(:subtype) { :datetime }

      context 'given time' do
        def serialize_and_deserialize(value)
          instance.deserialize(instance.serialize(value))
        end

        around do |example|
          travel_to(Time.current) do
            example.run
          end
        end

        it 'considers that time zone' do
          now = Time.now

          local_time = Time.use_zone('Asia/Tokyo') do
            Time.current
          end

          gmt_time = Time.use_zone('GMT') do
            Time.current
          end

          datetime_type = ActiveRecord::Type.lookup(:datetime)

          expect(datetime_type.cast(serialize_and_deserialize(local_time))).to eq(now)
          expect(datetime_type.cast(serialize_and_deserialize(gmt_time))).to eq(now)
        end
      end
    end
  end
end
