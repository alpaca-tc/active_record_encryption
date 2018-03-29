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

    it 'is length((characterLength/16 + 1) * 16)' do
      expect(instance.encrypt('a').length).to eq(16)
      expect(instance.encrypt('a' * 16).length).to eq(32)

      expect(instance.encrypt('🍺').length).to eq(16)
      expect(instance.encrypt('🍺' * 3).length).to eq(16)
      expect(instance.encrypt('🍺' * 4).length).to eq(32)
    end
  end

  describe '#decrypt' do
    subject { instance.decrypt(encrypted_value) }
    let(:encrypted_value) { described_class.new(password: password, salt: salt).encrypt(value) }

    context 'decrypt by invalid salt' do
      let(:instance) { described_class.new(password: password) }
      let(:value) { 'value' }
      it { expect { subject }.to raise_error(OpenSSL::Cipher::CipherError) }
    end

    context 'decrypt by valid salt/password' do
      let(:encrypted_value) { instance.encrypt(value) }
      let(:value) { '港区芝5-33-1' } # 3byte characters

      fit 'decrypts value from encrypted' do
        is_expected.to eq(value)
      end
    end
  end
end
