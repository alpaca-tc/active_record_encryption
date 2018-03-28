# frozen_string_literal: true

RSpec.describe ActiverecordEncryption::CommentSchema do
  before do
    ActiverecordEncryption.cipher = build_cipher
  end

  describe 'no comment' do
    stub_model('Post', adapter: :mysql2) do
      model do
        include(ActiverecordEncryption::CommentSchema)
      end

      table do |t|
        t.binary :date
        t.binary :boolean
      end
    end

    it "doesn't encrypt column" do
      date = Date.new
      boolean = true

      post = Post.create!(date: date, boolean: boolean)
      expect(post.date).to be_a(String)
      expect(post.boolean).to be_a(String)
    end
  end

  describe 'Simple comment' do
    stub_model('Post', adapter: :mysql2) do
      model do
        include(ActiverecordEncryption::CommentSchema)

        encrypted_attribute :decimal_with_options, ActiveRecord::Type.lookup(:decimal, precision: 3, scale: 3)
        encrypted_attribute :date_with_default, :date, default: -> { Date.current }
      end

      table do |t|
        t.binary :date, comment: 'encrypted_attribute(:date)'
        t.binary :date_with_default, comment: 'encrypted_attribute(:date)'
        t.binary :decimal, comment: 'encrypted_attribute(:decimal)'
        t.binary :decimal_with_options, comment: 'encrypted_attribute(:decimal)'
        t.binary :boolean, comment: 'encrypted_attribute(:boolean)'
      end
    end

    it 'encrypts column with no option' do
      date = Date.new
      boolean = true

      post = Post.create!(date: date, boolean: boolean)
      expect(post.date).to be_a(Date)
      expect(post.boolean).to be_a(TrueClass)
    end

    it 'encrypts column with default' do
      post = Post.create!
      expect(post.date_with_default).to be_a(Date)
    end

    it 'encrypts column with custom type' do
      post = Post.new(decimal_with_options: 54_321.12345)
      expect(post.decimal_with_options).to eql(54_300)
    end
  end
end
