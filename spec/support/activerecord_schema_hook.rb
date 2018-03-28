# frozen_string_literal: true

Module.new do
  extend ActiveSupport::Concern

  included do
    # stub module variables
    before do
      allow(described_class).to receive(:registry).and_return(registry)
    end

    after do
      ActiverecordSchemaHook::Hooks.dependencies.clear
    end

    let(:registry) { {} }
  end

  RSpec.configure do |config|
    config.include(self)
  end
end
