# frozen_string_literal: true

RSpec.describe ActiverecordEncryption::Core do
  describe '.encrypted_attributes' do
    before do
      ActiverecordEncryption.cipher = build_cipher
    end

    stub_model('Post') do
      model do
        include(ActiverecordEncryption::Core)

        encrypted_attributes(
          string: :string,
          date: :date,
          datetime: :datetime,
          time: :time,
          integer: :integer,
          float: :float,
          decimal: :decimal
        )
      end

      table do |t|
        t.binary :string
        t.binary :date
        t.binary :datetime
        t.binary :time
        t.binary :integer
        t.binary :float
        t.binary :decimal
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
          $DEBUG = true
          relation = Post.where(column => value)
          expect(relation).to eq([instance])
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

          it 'encrypts with specific cipher' do
            ActiverecordEncryption.cipher = build_cipher
            expect { find_instance.inspect }.to raise_error(OpenSSL::Cipher::CipherError)
          end
        end
      end
    end

    describe 'string' do
      it_behaves_like 'a encrypted column', column: :string, value: 'text', expected: 'text'
      it_behaves_like 'a encrypted column', column: :string, value: 1, expected: '1'
      it_behaves_like 'a encrypted column', column: :string, value: nil, expected: nil
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
    end

    describe 'float' do
      it_behaves_like 'a encrypted column', column: :float, value: 0.33, expected: 0.33
      it_behaves_like 'a encrypted column', column: :float, value: 1, expected: 1.0
      it_behaves_like 'a encrypted column', column: :float, value: -1, expected: -1.0
      it_behaves_like 'a encrypted column', column: :float, value: '1.33', expected: 1.33
      it_behaves_like 'a encrypted column', column: :float, value: nil, expected: nil
    end
  end
end
