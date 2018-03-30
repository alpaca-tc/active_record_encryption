# frozen_string_literal: true

RSpec.describe ActiverecordEncryption do
  it 'has a version number' do
    expect(ActiverecordEncryption::VERSION).not_to be nil
  end

  describe 'with_cipher' do
    before do
      described_class.cipher = nil
    end

    it 'assigns cipher in the block' do
      cipher = ActiverecordEncryption::Cipher.new

      expect(described_class.cipher).to be_nil

      ActiverecordEncryption.with_cipher(cipher) do
        expect(described_class.cipher).to eq(cipher)
      end

      expect(described_class.cipher).to be_nil
    end
  end
end
