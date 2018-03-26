# frozen_string_literal: true

RSpec.describe ActiverecordEncryption::EncryptedAttributes do
  describe 'ClassMethods' do
    describe '.encrypted_attributes' do
      stub_model('User') do
        model do
          include(ActiverecordEncryption::EncryptedAttributes)
        end

        table do |t|
          t.binary(:name)
        end
      end

      before do
        ActiverecordEncryption.cipher = build_cipher
      end

      it 'defines decorated attributes' do
        User.encrypted_attributes(name: :string)

        instance = User.new
        expect(instance.name).to be_nil

        instance.name = 'string'
        expect(instance.name).to eq('string')

        instance.save!
        result = User.connection.select_all("select * from users where id = #{instance.id}")

        id, name = result.rows.first

        expect(id).to eq(instance.id)
        expect(name).to_not eq(instance.name) # encypted
      end
    end
  end
end
