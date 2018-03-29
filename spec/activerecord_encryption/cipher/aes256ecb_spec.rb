# frozen_string_literal: true

RSpec.describe ActiverecordEncryption::Cipher::Aes256ecb do
  let(:instance) do
    described_class.new(key: key, iv: iv)
  end

  let(:key) { OpenSSL::Cipher.new('AES-256-ECB').random_key }
  let(:iv) { OpenSSL::Cipher.new('AES-256-ECB').random_iv }

  describe '#encrypt' do
    subject { instance.encrypt(value) }
    let(:value) { 'hello world' }

    it 'encrypts value' do
      is_expected.to_not eq(value)
      expect(instance.decrypt(subject)).to eq(value)
    end

    it 'is length((characterLength/16 + 1) * 16)' do
      expect(instance.encrypt('a').length).to eq(16)
      expect(instance.encrypt('a' * 16).length).to eq(32)

      expect(instance.encrypt('🍺').length).to eq(16)
      expect(instance.encrypt('🍺' * 3).length).to eq(16)
      expect(instance.encrypt('🍺' * 4).length).to eq(32)
    end
  end

  describe '#decrypt' do
    subject { instance.encrypt(value) }
    let(:value) { 'hello world' }

    it 'decrypts value from encrypted' do
      expect(instance.decrypt(subject)).to eq(value)
    end
  end
end
