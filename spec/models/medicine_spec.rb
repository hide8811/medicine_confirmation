require 'rails_helper'

RSpec.describe Medicine, type: :model do
  shared_examples '有効' do
    it { expect(medicine).to be_valid }
  end

  context '薬剤の名前・画像・参考サイトURLがあるとき' do
    let(:medicine) { build(:medicine) }
    it_behaves_like '有効'
  end

  describe 'column: name' do
    subject { medicine.errors[:name] }

    context '空の場合' do
      let(:medicine) { build(:medicine, name: '') }

      before { medicine.valid? }

      it { is_expected.to include("can't be blank") }
    end

    context '重複する場合' do
      context '大文字・小文字が同じとき' do
        let(:medicine) { build(:medicine, name: 'test_medicine') }

        before do
          create(:medicine, name: 'test_medicine')
          medicine.valid?
        end

        it { is_expected.to include('has already been taken') }
      end

      context '大文字・小文字が違うとき' do
        let(:medicine) { build(:medicine, name: 'TEST_medicine') }

        before do
          create(:medicine, name: 'test_medicine')
          medicine.valid?
        end

        it { is_expected.to include('has already been taken') }
      end

      context 'discarded_atに値があるとき' do
        let(:medicine) { build(:medicine, name: 'test_medicine') }

        before do
          create(:medicine, name: 'test_medicine', discarded_at: DateTime.now)
          medicine.valid?
        end

        it_behaves_like '有効'
      end

      context 'discarded_atに値がないとき' do
        let(:medicine) { build(:medicine, name: 'test_medicine') }

        before do
          create(:medicine, name: 'test_medicine', discarded_at: nil)
          medicine.valid?
        end

        it { is_expected.to include('has already been taken') }
      end
    end
  end

  describe 'column: iamge' do
    context '空の場合' do
      let(:medicine) { build(:medicine, image: '') }
      it_behaves_like '有効'
    end
  end

  describe 'column: url' do
    context '空の場合' do
      let(:medicine) { build(:medicine, url: '') }
      it_behaves_like '有効'
    end
  end
end
