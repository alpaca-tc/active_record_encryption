# frozen_string_literal: true

module TemporaryModel
  def create_temporary_model(model_name, &block)
    klass = Class.new(ActiveRecord::Base, &block)
    stub_const(model_name, klass)
  end

  RSpec.configuration.include(self)
end
