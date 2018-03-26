# frozen_string_literal: true

module ActiverecordStubModel
  extend ActiveSupport::Concern

  included do
    before do
      stubbed_models.each(&:build)
    end

    after do
      stubbed_models.each(&:destroy)
    end

    let(:stubbed_models) { [] }
  end

  class_methods do
    def stub_model(model_name, &block)
      model = StubModel.new(model_name, &block)

      around do |example|
        stubbed_models.push(model)
        example.run
      end
    end
  end

  # Create stubbed model
  #
  # Example
  #   stub_model('User') do
  #     model do
  #       belongs_to(:comments)
  #
  #       validates :comments, presence: true
  #
  #       def with_comments
  #         comments.build
  #         save!
  #       end
  #     end
  #
  #     table do |t|
  #       t.string :name, null: false
  #       t.datetime :activated_at, null: false
  #       t.datetime
  #     end
  #   end
  class StubModel
    attr_reader :model_name, :model_block, :table_block

    def initialize(model_name, &block)
      @model_name = model_name.to_s
      @model_block = nil
      @table_block = nil

      instance_exec(&block)
    end

    def model(&block)
      @model_block = block
    end

    def table(&block)
      @table_block = block
    end

    def build
      create_temporary_model if model_block
      create_temporary_table if table_block
    end

    def destroy
      ActiveRecord::Base.connection.drop_table(table_name) if table_block
      Object.send(:remove_const, @model_name)
    end

    private

    def table_name
      @model_name.tableize
    end

    def create_temporary_model
      klass = Class.new(ActiveRecord::Base, &model_block)
      Object.const_set(model_name, klass)
    end

    def create_temporary_table
      ActiveRecord::Base.connection.create_table(table_name, force: true, &table_block)
    end
  end

  RSpec.configuration.include(self)
end
