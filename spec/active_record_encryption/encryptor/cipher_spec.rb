# frozen_string_literal: true

RSpec.describe ActiverecordEncryption::Encryptor::Cipher do
  let(:instance) do
    described_class.new
  end

  describe '#encrypt' do
    subject { instance.encrypt(value) }
    let(:value) { 'value' }

    it 'encrypts value' do
      is_expected.to be_present
    end
  end

  describe '#decrypt' do
    subject { instance.decrypt(value) }
    let(:value) { 'value' }

    it 'decrypts value' do
      is_expected.to be_present
    end
  end
end
