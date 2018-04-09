# frozen_string_literal: true

RSpec.describe ActiveRecordEncryption::Type do
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

    before do
      ActiveRecordEncryption.cipher = cipher
    end

    let(:instance) { described_class.new(subtype: subtype) }
    let(:cipher) { build_cipher }

    context 'when subtype is integer' do
      let(:subtype) { :integer }

      context 'given "1"' do
        let(:value) { ActiveRecordEncryption::Encryptor.encrypt('1') }
        it { is_expected.to eq(1) }
      end
    end
  end

  describe '#serialize' do
    subject { instance.serialize(value) }

    before do
      ActiveRecordEncryption.cipher = build_cipher
    end

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
