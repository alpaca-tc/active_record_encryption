# frozen_string_literal: true

RSpec.describe ActiveRecordEncryption do
  it 'has a version number' do
    expect(ActiveRecordEncryption::VERSION).not_to be nil
  end

  describe 'ClassMethods' do
    describe '.default_encryption/.default_encryption=' do
      around do |example|
        original = described_class.default_encryption
        example.run
        described_class.default_encryption = original
      end

      it 'set default encryption' do
        new_encryption = { encryptor: :active_support, key: 'xxx', salt: 'xxx' }
        described_class.default_encryption = new_encryption
        expect(described_class.default_encryption).to eq(new_encryption)
      end
    end
  end
end
