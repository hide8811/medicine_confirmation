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
    context '空の場合' do
      let(:medicine) { build(:medicine, name: '') }

      it '無効なこと' do
        medicine.valid?
        expect(medicine.errors[:name]).to include("can't be blank")
      end
    end

    context '重複する場合' do
      before do
        create(:medicine, name: 'test_medicine')
      end

      let(:medicine) { build(:medicine, name: 'test_medicine') }
      it '無効なこと' do
        medicine.valid?
        expect(medicine.errors[:name]).to include('has already been taken')
      end

      let(:uppercase_medicine) { build(:medicine, name: 'TEST_medicine') }
      it '大文字小文字が違っていても無効なこと' do
        uppercase_medicine.valid?
        expect(uppercase_medicine.errors[:name]).to include('has already been taken')
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
