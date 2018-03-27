# frozen_string_literal: true

RSpec.describe ActiverecordSchemaHook::Hooks do
  describe 'ClassMethods' do
    describe '.register' do
      subject do
        -> { described_class.register(:activerecord_encryption, Class, matcher: ->(*) { true }) }
      end

      before do
        allow(described_class).to receive(:registry).and_return(registry)
      end

      let(:registry) { ActiverecordSchemaHook::Hooks::Registry.new }

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
        allow(described_class).to receive(:registry).and_return(registry)
        described_class.register(:activerecord_encryption, Class, matcher: ->(*) { true })
      end

      let(:registry) { ActiverecordSchemaHook::Hooks::Registry.new }

      it 'deregister hook' do
        is_expected.to change {
          registry.send(:registrations).size
        }.from(1).to(0)
      end
    end
  end
end
