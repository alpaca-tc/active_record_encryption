# frozen_string_literal: true

RSpec.describe ActiveRecordEncryption::EncryptedAttribute do
  describe 'ClassMethod' do
    before do
      mock_encryptor = Class.new(ActiveRecordEncryption::Encryptor::Raw) do
        def encrypt(value)
          "#{super}mock"
        end

        def decrypt(value)
          super.sub(/mock$/, '')
        end
      end

      allow(ActiveRecordEncryption).to receive(:default_encryption).and_return(
        encryptor: mock_encryptor
      )
    end

    describe 'encryption' do
      stub_model('Post') do
        model do
          encrypted_attribute(:string, :string)
          encrypted_attribute(:date, :date)
          encrypted_attribute(:datetime, :datetime)
          encrypted_attribute(:time, :time)
          encrypted_attribute(:integer, :integer)
          encrypted_attribute(:float, :float)
          encrypted_attribute(:decimal, :decimal)
          encrypted_attribute(:boolean, :boolean)
        end

        table do |t|
          t.binary :string
          t.binary :date
          t.binary :datetime
          t.binary :time
          t.binary :integer
          t.binary :float
          t.binary :decimal
          t.binary :boolean
        end
      end

      shared_examples_for 'a encrypted column' do |column:, value:, expected:|
        context "given #{value.inspect} to #{column}" do
          let!(:instance) do
            Post.create!(column => value)
          end

          def find_instance
            Post.find(instance.id)
          end

          it 'decrypts value from database' do
            expect(find_instance.public_send(column)).to eq(expected)
          end

          it 'finds by encrypted value' do
            relation = Post.where(column => value)
            expect(relation).to eq([instance])
          end

          it 'cast value' do
            post = Post.create!(column => expected)
            expect(post.public_send(column)).to eq(expected)

            post.public_send(:"#{column}=", value)
            expect(post).to_not be_changed

            post.public_send(:"#{column}=", expected)
            expect(post).to_not be_changed
          end

          if value.nil?
            it 'encrypts value in predicate query' do
              relation = Post.where(column => value)
              expect(relation.to_sql).to include('IS NULL')
            end
          else
            it 'encrypts value in predicate query' do
              relation = Post.where(column => value)
              ruby_value = Post.new(column => value).public_send(column)
              db_value = Post.connection.send(:type_cast, ruby_value)
              expect(relation.to_sql).to_not include(%("#{db_value}"))
            end

            it 'encrypts value in database' do
              in_database = find_instance.public_send("#{column}_before_type_cast")

              expect(in_database).to_not eq(expected)
              expect(in_database).to_not eq(value)
              expect(in_database).to_not be_nil
            end
          end
        end
      end

      describe 'string' do
        it_behaves_like 'a encrypted column', column: :string, value: 'text', expected: 'text'
        it_behaves_like 'a encrypted column', column: :string, value: 1, expected: '1'
        it_behaves_like 'a encrypted column', column: :string, value: nil, expected: nil
        it_behaves_like 'a encrypted column', column: :string, value: 'あ', expected: 'あ'
        it_behaves_like 'a encrypted column', column: :string, value: 'ミョウジ', expected: 'ミョウジ'
        it_behaves_like 'a encrypted column', column: :string, value: '🍺', expected: '🍺'

        it 'supports serialize' do
          klass = Class.new(Post) do
            serialize(:string)
          end

          instance = klass.new(string: [1, 2, 3])
          expect(instance.string).to eq([1, 2, 3])
          instance.save!
          expect(instance.string).to eq([1, 2, 3])
          expect(instance.string_before_type_cast).to eq("---\n- 1\n- 2\n- 3\nmock")
        end
      end

      describe 'datetime' do
        it_behaves_like 'a encrypted column', column: :datetime, value: Time.at(0), expected: Time.at(0).utc
        it_behaves_like 'a encrypted column', column: :datetime, value: '2018-01-01 00:00:00 +09:00', expected: Time.new(2018, 1, 1, 0, 0, 0, '+09:00')
        it_behaves_like 'a encrypted column', column: :datetime, value: '2018-01-01', expected: Time.new(2018, 1, 1, 0, 0, 0, '+00:00')
        it_behaves_like 'a encrypted column', column: :datetime, value: nil, expected: nil
      end

      describe 'decimal' do
        it_behaves_like 'a encrypted column', column: :decimal, value: 0.33, expected: 0.33
        it_behaves_like 'a encrypted column', column: :decimal, value: 1, expected: 1.0
        it_behaves_like 'a encrypted column', column: :decimal, value: -1, expected: -1.0
        it_behaves_like 'a encrypted column', column: :decimal, value: '0.33', expected: 0.33
        it_behaves_like 'a encrypted column', column: :decimal, value: nil, expected: nil
      end

      describe 'integer' do
        it_behaves_like 'a encrypted column', column: :integer, value: 0.33, expected: 0
        it_behaves_like 'a encrypted column', column: :integer, value: 1, expected: 1.0
        it_behaves_like 'a encrypted column', column: :integer, value: -1, expected: -1.0
        it_behaves_like 'a encrypted column', column: :integer, value: '1.33', expected: 1
        it_behaves_like 'a encrypted column', column: :integer, value: nil, expected: nil

        # If you want to encrypt enum column, apply the following monkey patch.
        # Module.new do
        #   def serialize(value)
        #     serialized = subtype.serialize(value)
        #     mapping.fetch(serialized, serialized)
        #   end
        #
        #   ActiveRecord::Enum::EnumType.prepend(self)
        # end
        pending 'supports enum' do
          klass = Class.new(Post) do
            enum integer: %w[positive negative]
          end

          instance = klass.new

          instance.integer = 'positive'
          expect(instance.integer).to eq('positive')
          expect(instance.negative?).to be false
          expect(instance.positive?).to be true

          instance.integer = 'negative'
          expect(instance.integer).to eq('negative')
          expect(instance.negative?).to be true
          expect(instance.positive?).to be false

          instance.save!
          expect(instance.integer).to eq('negative')
        end
      end

      describe 'float' do
        it_behaves_like 'a encrypted column', column: :float, value: 0.33, expected: 0.33
        it_behaves_like 'a encrypted column', column: :float, value: 1, expected: 1.0
        it_behaves_like 'a encrypted column', column: :float, value: -1, expected: -1.0
        it_behaves_like 'a encrypted column', column: :float, value: '1.33', expected: 1.33
        it_behaves_like 'a encrypted column', column: :float, value: nil, expected: nil
      end

      describe 'boolean' do
        it_behaves_like 'a encrypted column', column: :boolean, value: 0.33, expected: true
        it_behaves_like 'a encrypted column', column: :boolean, value: 1, expected: true
        it_behaves_like 'a encrypted column', column: :boolean, value: '-1', expected: true
        it_behaves_like 'a encrypted column', column: :boolean, value: 't', expected: true
        it_behaves_like 'a encrypted column', column: :boolean, value: true, expected: true
        it_behaves_like 'a encrypted column', column: :boolean, value: false, expected: false
        it_behaves_like 'a encrypted column', column: :boolean, value: '0', expected: false
        it_behaves_like 'a encrypted column', column: :boolean, value: 0, expected: false
        it_behaves_like 'a encrypted column', column: :boolean, value: nil, expected: nil
      end
    end

    describe 'with default value' do
      stub_model('Post') do
        model do
          encrypted_attribute(:simple, :string, default: 'default')
          encrypted_attribute(:proc, :string, default: -> { 'default' })
          encrypted_attribute(:object, :string, default: [])
        end

        table do |t|
          t.binary :simple
          t.binary :proc
          t.binary :object
        end
      end

      it 'initialize with default value' do
        instance = Post.new

        expect(instance.simple).to eq('default')
        expect(instance.proc).to eq('default')
        expect(instance.object).to eq('[]')
      end
    end
  end
end
