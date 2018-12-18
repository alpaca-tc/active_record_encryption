# frozen_string_literal: true

RSpec.describe ActiveRecordEncryption::Encryptor::ActiveSupport do
  describe 'InstanceMethods' do
    let(:key) { 'ecf4790ae8756ce1edfb935d306836c4ee5b1fe32d443b78e727f85e8d2768369e6fdd5df981c2bcfbd4f6e1027acc44de5436df486d8bef0a79bb66593b8981' }
    let(:salt) { '97f2d962079d157d2a8f819af4a42ced892383be15ee1f7da6812592e284c819808ea93bda2f0dbbab8e4dcef6003a3c9e4b98ac76f32cca8dc89cf94436664a' }

    describe '#initialize' do
      context 'missing arguments' do
        it 'raises ArgumentError' do
          expect { described_class.new(salt: salt) }.to raise_error(ArgumentError)
          expect { described_class.new(key: key) }.to raise_error(ArgumentError)
        end
      end

      context 'with cipher' do
        let(:instance) { described_class.new(salt: salt, key: key, cipher: cipher) }

        def new_cipher
          instance.instance_variable_get(:@encryptor).send(:new_cipher)
        end

        context 'cipher is "aes-256-gcm"' do
          let(:cipher) { 'aes-256-gcm' }

          it 'builds aes-256-gcm encryptor' do
            expect(new_cipher.name).to eq('id-aes256-GCM')
          end
        end

        context 'cipher is "aes-256-cbc"' do
          let(:cipher) { 'aes-256-cbc' }

          it 'builds aes-256-cbc encryptor' do
            expect(new_cipher.name).to eq('AES-256-CBC')
          end
        end
      end
    end

    describe '#encrypt/decrypt' do
      let(:instance) { described_class.new(key: key, salt: salt) }

      it 'encrypts value with ActiveSupport::MessageEncryptor' do
        value = Date.parse('2000/01/01')

        encrypted_1 = instance.encrypt(value)
        encrypted_2 = instance.encrypt(value)

        expect(encrypted_1).to_not eq(value)
        expect(encrypted_1).to_not eq(encrypted_2)

        expect(instance.decrypt(encrypted_1)).to eq('2000-01-01')
        expect(instance.decrypt(encrypted_2)).to eq('2000-01-01')
      end
    end

    describe '#==' do
      it 'compares with other encryptor' do
        # Same encryptor
        instance_1 = described_class.new(key: key, salt: salt)
        instance_2 = described_class.new(key: key, salt: salt)

        # Other encryptor
        instance_3 = described_class.new(key: key, salt: SecureRandom.hex(64))
        instance_4 = described_class.new(key: SecureRandom.hex(64), salt: salt)

        expect(instance_1).to eq(instance_1)

        # In the case of generated ActiveSupport::MessageEncryptor from same arguments,
        # it always return false.
        expect(instance_1).to_not eq(instance_2)
        expect(instance_1).to_not eq(instance_3)
        expect(instance_1).to_not eq(instance_4)
      end
    end
  end
end
