# frozen_string_literal: true

RSpec.describe ActiverecordEncryption::Cipher::Aes256cbc do
  let(:instance) do
    described_class.new(password: password, salt: salt)
  end

  let(:password) { 'password' }
  let(:salt) { OpenSSL::Random.random_bytes(8) }

  describe '#encrypt' do
    subject { instance.encrypt(value) }
    let(:value) { 'hello world' }

    it 'encrypts value' do
      is_expected.to_not eq(value)
      expect(instance.decrypt(subject)).to eq(value)
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
