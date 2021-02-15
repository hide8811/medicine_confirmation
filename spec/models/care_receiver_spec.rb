require 'rails_helper'

RSpec.describe CareReceiver, type: :model do
  shared_examples '有効' do
    it { expect(care_receiver).to be_valid }
  end

  context 'last_name, first_name, last_name_kana, first_name_kana, birthday, enrollの有無がある場合' do
    let(:care_receiver) { build(:care_receiver) }
    it_behaves_like '有効'
  end

  describe 'column: last_name' do
    context 'ひらがなの場合' do
      let(:care_receiver) { build(:care_receiver, last_name: 'てすと') }
      it_behaves_like '有効'
    end

    context 'カタカナの場合' do
      let(:care_receiver) { build(:care_receiver, last_name: 'テスト') }
      it_behaves_like '有効'
    end

    context 'ローマ字の場合' do
      let(:care_receiver) { build(:care_receiver, last_name: 'test') }
      it_behaves_like '有効'
    end

    context '重複している場合' do
      before do
        create(:care_receiver, last_name: 'テスト')
      end

      let(:care_receiver) { build(:care_receiver, last_name: 'テスト') }
      it_behaves_like '有効'
    end

    context '空の場合' do
      it '無効であること' do
        care_receiver = build(:care_receiver, last_name: '')
        care_receiver.valid?
        expect(care_receiver.errors[:last_name]).to include("can't be blank")
      end
    end
  end

  describe 'column: first_name' do
    context 'ひらがなの場合' do
      let(:care_receiver) { build(:care_receiver, first_name: 'てすと') }
      it_behaves_like '有効'
    end

    context 'カタカナの場合' do
      let(:care_receiver) { build(:care_receiver, first_name: 'テスト') }
      it_behaves_like '有効'
    end

    context 'ローマ字の場合' do
      let(:care_receiver) { build(:care_receiver, first_name: 'test') }
      it_behaves_like '有効'
    end

    context '重複している場合' do
      before do
        create(:care_receiver, first_name: 'テスト')
      end

      let(:care_receiver) { build(:care_receiver, first_name: 'テスト') }
      it_behaves_like '有効'
    end

    context '空の場合' do
      it '無効であること' do
        care_receiver = build(:care_receiver, first_name: '')
        care_receiver.valid?
        expect(care_receiver.errors[:first_name]).to include("can't be blank")
      end
    end
  end

  describe 'column: last_name_kana' do
    context '重複している場合' do
      before do
        create(:care_receiver, last_name_kana: 'てすと')
      end

      let(:care_receiver) { build(:care_receiver, last_name_kana: 'てすと') }
      it_behaves_like '有効'
    end

    context '漢字の場合' do
      it '無効であること' do
        care_receiver = build(:care_receiver, last_name_kana: '試験')
        care_receiver.valid?
        expect(care_receiver.errors[:last_name_kana]).to include('is invalid')
      end
    end

    context 'カタカナの場合' do
      it '無効であること' do
        care_receiver = build(:care_receiver, last_name_kana: 'テスト')
        care_receiver.valid?
        expect(care_receiver.errors[:last_name_kana]).to include('is invalid')
      end
    end

    context 'ローマ字の場合' do
      it '無効であること' do
        care_receiver = build(:care_receiver, last_name_kana: 'test')
        care_receiver.valid?
        expect(care_receiver.errors[:last_name_kana]).to include('is invalid')
      end
    end

    context '空の場合' do
      it '無効であること' do
        care_receiver = build(:care_receiver, last_name_kana: '')
        care_receiver.valid?
        expect(care_receiver.errors[:last_name_kana]).to include("can't be blank")
      end
    end
  end

  describe 'column: first_name_kana' do
    context '重複している場合' do
      before do
        create(:care_receiver, first_name_kana: 'てすと')
      end

      let(:care_receiver) { build(:care_receiver, first_name_kana: 'てすと') }
      it_behaves_like '有効'
    end

    context '漢字の場合' do
      it '無効であること' do
        care_receiver = build(:care_receiver, first_name_kana: '試験')
        care_receiver.valid?
        expect(care_receiver.errors[:first_name_kana]).to include('is invalid')
      end
    end

    context 'カタカナの場合' do
      it '無効であること' do
        care_receiver = build(:care_receiver, first_name_kana: 'テスト')
        care_receiver.valid?
        expect(care_receiver.errors[:first_name_kana]).to include('is invalid')
      end
    end

    context 'ローマ字の場合' do
      it '無効であること' do
        care_receiver = build(:care_receiver, first_name_kana: 'test')
        care_receiver.valid?
        expect(care_receiver.errors[:first_name_kana]).to include('is invalid')
      end
    end

    context '空の場合' do
      it '無効であること' do
        care_receiver = build(:care_receiver, first_name_kana: '')
        care_receiver.valid?
        expect(care_receiver.errors[:first_name_kana]).to include("can't be blank")
      end
    end
  end

  describe 'column: birthday' do
    context '重複している場合' do
      before do
        create(:care_receiver, birthday: '2000-01-01')
      end

      let(:care_receiver) { build(:care_receiver, birthday: '2000-01-01') }
      it_behaves_like '有効'
    end

    context '空の場合' do
      it '無効であること' do
        care_receiver = build(:care_receiver, birthday: '')
        care_receiver.valid?
        expect(care_receiver.errors[:birthday]).to include("can't be blank")
      end
    end
  end
end
