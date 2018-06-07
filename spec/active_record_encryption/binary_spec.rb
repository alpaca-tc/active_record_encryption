# frozen_string_literal: true

RSpec.describe ActiveRecordEncryption::Binary do
  describe 'InstanceMethods' do
    let(:instance) { described_class.new(*options) }

    describe 'read_string_255/write_string_255' do
      let(:options) { [] }

      it do
        instance.write_string_255('hello')
        instance.write('dust')
        instance.rewind

        expect(instance.read_string_255).to eq('hello')
      end
    end
  end
end
