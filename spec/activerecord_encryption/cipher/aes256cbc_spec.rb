# frozen_string_literal: true

RSpec.describe ActiverecordEncryption::Cipher::Aes256cbc do
  let(:instance) do
    described_class.new(password: password, salt: salt)
  end

  let(:password) { 'password' }
  let(:salt) { OpenSSL::Random.random_bytes(8) }

  describe '#decrypt' do
    subject { instance.encrypt(value) }
    let(:value) { 'hello world' }
    it { expect(instance.decrypt(subject)).to eq(value) }
  end
end
