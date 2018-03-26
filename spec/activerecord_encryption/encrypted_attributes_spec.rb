# frozen_string_literal: true

RSpec.describe ActiverecordEncryption::EncryptedAttributes do
  describe 'ClassMethods' do
    describe '.encrypted_attributes' do
      let(:klass) do
        create_temporary_model('User') do
          include(ActiverecordEncryption::EncryptedAttributes)
        end
      end

      before do
        ActiverecordEncryption.cipher = build_cipher
      end

      create_table(:users) do |t|
        t.binary(:name)
      end

      it 'defines decorated attributes' do
        klass.encrypted_attributes(name: :string)

        instance = klass.new
        expect(instance.name).to be_nil

        instance.name = 'string'
        expect(instance.name).to eq('string')

        instance.save!
        result = ActiveRecord::Base.connection.select_all("select * from users where id = #{instance.id}")

        id, name = result.rows.first

        expect(id).to eq(instance.id)
        expect(name).to_not eq(instance.name) # encypted
      end
    end
  end
end
