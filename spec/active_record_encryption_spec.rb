# frozen_string_literal: true

RSpec.describe ActiveRecordEncryption do
  it 'has a version number' do
    expect(ActiveRecordEncryption::VERSION).not_to be nil
  end

  describe 'with_cipher' do
    before do
      described_class.cipher = nil
    end

    it 'assigns cipher in the block' do
      cipher = build_cipher

      expect(described_class.cipher).to be_nil

      ActiveRecordEncryption.with_cipher(cipher) do
        expect(described_class.cipher).to eq(cipher)
      end

      expect(described_class.cipher).to be_nil
    end
  end
end
