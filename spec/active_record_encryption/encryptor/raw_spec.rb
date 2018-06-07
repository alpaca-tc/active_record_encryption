# frozen_string_literal: true

RSpec.describe ActiveRecordEncryption::Encryptor::Raw do
  describe 'InstanceMethods' do
    let(:instance) { described_class.new }

    describe '#encrypt' do
      it 'calls ActiveRecordEncryption::Quoter#type_cast' do
        value = Date.parse('2000/01/01')
        expect(ActiveRecordEncryption::Quoter.instance).to receive(:type_cast).with(value)
        instance.encrypt(value)
      end

      it 'returns String or nil' do
        expect(instance.encrypt(true)).to be_a(String).or(be_nil)
      end
    end
  end
end
