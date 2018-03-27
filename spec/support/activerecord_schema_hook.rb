# frozen_string_literal: true

Module.new do
  extend ActiveSupport::Concern

  included do
    before do
      allow(described_class).to receive(:registry).and_return(registry)
    end

    let(:registry) { ActiverecordSchemaHook::Hooks::Registry.new }
  end

  RSpec.configure do |config|
    config.include(self)
  end
end
