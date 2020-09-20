require 'rails_helper'

RSpec.describe CareReceiver, type: :model do
  shared_examples '有効' do
    it { expect(care_receiver).to be_valid }
  end

  context '名字・名前・みょうじ・なまえ・生年月日・在籍の有無がある場合' do
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
        create(:care_receiver, last_name: last_name)
      end

      let(:last_name) { Gimei.last.kanji }
      let(:care_receiver) { build(:care_receiver, last_name: last_name) }
      it_behaves_like '有効'
    end

    context 'カラの場合' do
      let(:care_receiver) { build(:care_receiver, last_name: '') }

      it '無効であること' do
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
        create(:care_receiver, first_name: first_name)
      end

      let(:first_name) { Gimei.first.kanji }
      let(:care_receiver) { build(:care_receiver, first_name: first_name) }
      it_behaves_like '有効'
    end

    context 'カラの場合' do
      let(:care_receiver) { build(:care_receiver, first_name: '') }

      it '無効であること' do
        care_receiver.valid?
        expect(care_receiver.errors[:first_name]).to include("can't be blank")
      end
    end
  end

  describe 'column: last_name_kana' do
    context '重複している場合' do
      before do
        create(:care_receiver, last_name_kana: last_name_kana)
      end

      let(:last_name_kana) { Gimei.last.hiragana }
      let(:care_receiver) { build(:care_receiver, last_name_kana: last_name_kana) }
      it_behaves_like '有効'
    end

    context '漢字の場合' do
      let(:care_receiver) { build(:care_receiver, last_name_kana: '試験') }

      it '無効であること' do
        care_receiver.valid?
        expect(care_receiver.errors[:last_name_kana]).to include('is invalid')
      end
    end

    context 'カタカナの場合' do
      let(:care_receiver) { build(:care_receiver, last_name_kana: 'テスト') }

      it '無効であること' do
        care_receiver.valid?
        expect(care_receiver.errors[:last_name_kana]).to include('is invalid')
      end
    end

    context 'ローマ字の場合' do
      let(:care_receiver) { build(:care_receiver, last_name_kana: 'test') }

      it '無効であること' do
        care_receiver.valid?
        expect(care_receiver.errors[:last_name_kana]).to include('is invalid')
      end
    end

    context 'カラの場合' do
      let(:care_receiver) { build(:care_receiver, last_name_kana: '') }

      it '無効であること' do
        care_receiver.valid?
        expect(care_receiver.errors[:last_name_kana]).to include("can't be blank")
      end
    end
  end

  describe 'column: first_name_kana' do
    context '重複している場合' do
      before do
        create(:care_receiver, first_name_kana: first_name_kana)
      end

      let(:first_name_kana) { Gimei.first.hiragana }
      let(:care_receiver) { build(:care_receiver, first_name_kana: first_name_kana) }
      it_behaves_like '有効'
    end

    context '漢字の場合' do
      let(:care_receiver) { build(:care_receiver, first_name_kana: '試験') }

      it '無効であること' do
        care_receiver.valid?
        expect(care_receiver.errors[:first_name_kana]).to include('is invalid')
      end
    end

    context 'カタカナの場合' do
      let(:care_receiver) { build(:care_receiver, first_name_kana: 'テスト') }

      it '無効であること' do
        care_receiver.valid?
        expect(care_receiver.errors[:first_name_kana]).to include('is invalid')
      end
    end

    context 'ローマ字の場合' do
      let(:care_receiver) { build(:care_receiver, first_name_kana: 'test') }

      it '無効であること' do
        care_receiver.valid?
        expect(care_receiver.errors[:first_name_kana]).to include('is invalid')
      end
    end

    context 'カラの場合' do
      let(:care_receiver) { build(:care_receiver, first_name_kana: '') }

      it '無効であること' do
        care_receiver.valid?
        expect(care_receiver.errors[:first_name_kana]).to include("can't be blank")
      end
    end
  end

  describe 'column: birthday' do
    context '重複している場合' do
      before do
        create(:care_receiver, birthday: birthday)
      end

      let(:birthday) { Faker::Date.birthday(min_age: 65, max_age: 120) }
      let(:care_receiver) { build(:care_receiver, birthday: birthday) }
      it_behaves_like '有効'
    end

    context 'カラの場合' do
      let(:care_receiver) { build(:care_receiver, birthday: '') }

      it '無効であること' do
        care_receiver.valid?
        expect(care_receiver.errors[:birthday]).to include("can't be blank")
      end
    end
  end

  describe 'column: enroll' do
    context 'trueの場合' do
      let(:care_receiver) { build(:care_receiver, enroll: true) }
      it_behaves_like '有効'
    end

    context 'falseの場合' do
      let(:care_receiver) { build(:care_receiver, enroll: false) }
      it_behaves_like '有効'
    end

    context 'nilの場合' do
      let(:care_receiver) { build(:care_receiver, enroll: nil) }

      it '無効であること' do
        care_receiver.valid?
        expect(care_receiver.errors[:enroll]).to include('is not included in the list')
      end
    end
  end
end
