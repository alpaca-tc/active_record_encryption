# frozen_string_literal: true

RSpec.describe ActiveRecordEncryption::Quoter do
  describe '#type_cast' do
    subject { described_class.instance.type_cast(value) }

    def to_s(value, *args)
      if ActiveRecord::VERSION::MAJOR >= 7
        value.to_fs(*args)
      else
        value.to_s(*args)
      end
    end

    context 'given string' do
      let(:value) { 'hello world' }
      it { is_expected.to eq(value) }
    end

    context 'given symbol' do
      let(:value) { :hello_world }
      it { is_expected.to eq(value.to_s) }
    end

    context 'given true' do
      let(:value) { true }
      it { is_expected.to eq('t') }
    end

    context 'given false' do
      let(:value) { false }
      it { is_expected.to eq('f') }
    end

    context 'given BigDecimal' do
      let(:value) { BigDecimal('12345.12345') }
      it { is_expected.to eq('12345.12345') }
    end

    context 'given ActiveRecord::Type::Time::Value' do
      let(:value) { ActiveRecord::Type.lookup(:time).serialize(Time.now).change(usec: 0) }
      it { is_expected.to eq(to_s(value, :db)) }
    end

    context 'given Date' do
      let(:value) { Date.today }
      it { is_expected.to eq to_s(value, :db) }
    end

    context 'given Time' do
      let(:value) { Time.now.change(usec: 0) }
      it { is_expected.to eq to_s(value.utc, :db) }
    end

    context 'given Integer' do
      let(:value) { 1 }
      it { is_expected.to eq value.to_s }
    end

    context 'given Float' do
      let(:value) { 1.1 }
      it { is_expected.to eq value.to_s }
    end

    context 'given nil' do
      let(:value) { nil }
      it { is_expected.to be_nil }
    end
  end
end
