# frozen_string_literal: true

RSpec.describe ActiverecordSchemaHook::Hooks::Registry do
  describe 'InstanceMethods' do
    def registrations_length
      registry.send(:registrations).length
    end

    let(:registry) { described_class.new }

    describe '#register' do
      subject do
        -> { registry.register(:name, Class, ->(*) {}) }
      end

      it 'register hook' do
        is_expected.to change {
          registrations_length
        }.from(0).to(1)
      end
    end

    describe '#deregister' do
      subject do
        -> { registry.deregister(:name) }
      end

      before do
        registry.register(:name, Class, ->(*) {})
      end

      it 'deregister hook' do
        is_expected.to change {
          registrations_length
        }.from(1).to(0)
      end
    end
  end
end
