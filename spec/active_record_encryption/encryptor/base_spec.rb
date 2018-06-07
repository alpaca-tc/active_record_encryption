# frozen_string_literal: true

RSpec.describe ActiveRecordEncryption::Encryptor::Base do
  describe 'InstanceMethods' do
    let(:instance) { described_class.new }

    describe '#encrypt' do
      subject { instance.encrypt(value) }
      let(:value) { 'hello world' }
      it { is_expected.to eq(value) }
    end

    describe '#decrypt' do
      subject { instance.decrypt(value) }
      let(:value) { 'hello world' }
      it { is_expected.to eq(value) }
    end

    describe '#==' do
      it { expect(described_class.new).to eq(described_class.new) }
    end
  end
end
