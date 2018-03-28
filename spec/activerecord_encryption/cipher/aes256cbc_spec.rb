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

    context 'time' do
      def encrypt_and_decrypt(value)
        instance.decrypt(instance.encrypt(value))
      end

      it 'considers that time zone' do
        local_time = Time.use_zone('Asia/Tokyo') do
          Time.current
        end

        gmt_time = Time.use_zone('GMT') do
          Time.current
        end

        datetime_type = ActiveRecord::Type.lookup(:datetime)

        expect(datetime_type.cast(encrypt_and_decrypt(local_time))).to eq(local_time)
        expect(datetime_type.cast(encrypt_and_decrypt(gmt_time))).to eq(gmt_time)
      end
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
