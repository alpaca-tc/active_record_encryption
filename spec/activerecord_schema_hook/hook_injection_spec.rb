# frozen_string_literal: true

RSpec.describe ActiverecordSchemaHook::HookInjection do
  stub_model('Post', adapter: :mysql2) do
    model do
      include(ActiverecordSchemaHook::HookInjection)
    end

    table {}
  end

  describe 'on initialize' do
    context 'add virtual attribute' do
      before do
        ActiverecordSchemaHook::Hooks.register(:with_test_attribute) do |klass|
          klass.attribute(:test)
        end
      end

      it 'runs hooks' do
        instance = Post.new # Load schema and run hooks
        expect(instance.test).to be_nil
      end
    end

    context 'add decorated attribute' do
      before do
        ActiverecordSchemaHook::Hooks.register(:with_test_attribute) do |klass|
          klass.decorate_attribute_type(:id, :encrypted) do |_db_type|
            ActiveRecord::Type::String.new
          end
        end
      end

      it 'runs hooks' do
        instance = Post.new(id: 1) # Load schema and run hooks
        expect(instance.id).to eq('1')
      end
    end
  end
end
