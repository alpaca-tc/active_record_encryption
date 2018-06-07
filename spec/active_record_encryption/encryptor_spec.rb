# frozen_string_literal: true

RSpec.describe ActiveRecordEncryption::Encryptor do
  describe 'ClassMethods' do
    before do
      # Stub global object
      allow(described_class).to receive(:registry).and_return(registry)
    end

    let(:registry) { ActiveRecordEncryption::Encryptor::Registry.new }

    let(:awesome_encryptor) do
      Class.new(ActiveRecordEncryption::Encryptor::Base) do
        attr_reader :args

        def initialize(*args)
          super
          @args = args
        end

        def ==(other)
          super && args == other.args
        end
      end
    end

    describe '.register' do
      it 'register new encryptor' do
        described_class.register(:awesome_encryptor, awesome_encryptor)
        expect(described_class.lookup(:awesome_encryptor, :with_options)).to eq(awesome_encryptor.new(:with_options))
      end
    end
  end
end
