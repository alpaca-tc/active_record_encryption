# frozen_string_literal: true

RSpec.describe ActiverecordSchemaHook::Hooks do
  describe 'ClassMethods' do
    describe '.register' do
      subject do
        -> { described_class.register(:activerecord_encryption, Class, matcher: ->(*) { true }) }
      end

      it 'register hook' do
        is_expected.to change {
          registry.send(:registrations).size
        }.from(0).to(1)
      end
    end

    describe '.deregister' do
      subject do
        -> { described_class.deregister(:activerecord_encryption) }
      end

      before do
        described_class.register(:activerecord_encryption, Class, matcher: ->(*) { true })
      end

      it 'deregister hook' do
        is_expected.to change {
          registry.send(:registrations).size
        }.from(1).to(0)
      end
    end
  end
end
