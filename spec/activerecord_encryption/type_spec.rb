RSpec.describe ActiverecordEncryption::Type do
  describe '#cast' do
    subject { instance.cast(value) }

    let(:instance) { described_class.new(:name, subtype_instance) }
    let(:subtype_instance) { ActiveRecord::Type.lookup(subtype) }

    context 'when subtype is integer' do
      let(:subtype) { :integer }

      context 'given 1' do
        let(:value) { 1 }
        it { is_expected.to eq(1) }
      end

      context 'given "1"' do
        let(:value) { '1' }
        it { is_expected.to eq(1) }
      end
    end
  end
end
