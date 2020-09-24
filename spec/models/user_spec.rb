require 'rails_helper'

RSpec.describe User, type: :model do
  shared_examples '有効' do
    it { expect(user).to be_valid }
  end

  context 'employee_id, password, last_name_first_name, last_name_kana, first_name_kana に値がある場合' do
    let(:user) { build(:user) }
    it_behaves_like '有効'
  end

  describe 'column: employee_id' do
    context '空の場合' do
      it '無効であること' do
        user = build(:user, employee_id: '')
        user.valid?
        expect(user.errors[:employee_id]).to include("can't be blank")
      end
    end

    context '重複した場合' do
      before do
        create(:user, employee_id: 'id12345')
      end

      it '無効であること' do
        user = build(:user, employee_id: 'id12345')
        user.valid?
        expect(user.errors[:employee_id]).to include('has already been taken')
      end
    end
  end

  describe 'column: password' do
    context '半角の英大文字・英小文字・数字がそれぞれ1文字以上あり、文字数が8文字以上16文字以下である場合' do
      let(:user) { build(:user, password: 'TEst1234') }
      it_behaves_like '有効'
    end

    context '英大文字・英小文字・数字のが順不同である場合' do
      let(:user) { build(:user, password: '1te23ST4') }
      it_behaves_like '有効'
    end

    context '空の場合' do
      it '無効であること' do
        user = build(:user, password: '')
        user.valid?
        expect(user.errors[:password]).to include("can't be blank")
      end
    end

    context '英大文字がない場合' do
      it '無効であること' do
        user = build(:user, password: 'test1234')
        user.valid?
        expect(user.errors[:password]).to include('is invalid')
      end
    end

    context '英小文字がない場合' do
      it '無効であること' do
        user = build(:user, password: 'TEST1234')
        user.valid?
        expect(user.errors[:password]).to include('is invalid')
      end
    end

    context '数字がない場合' do
      it '無効であること' do
        user = build(:user, password: 'TestTest')
        user.valid?
        expect(user.errors[:password]).to include('is invalid')
      end
    end

    context '英大文字が全角の場合' do
      it '無効であること' do
        user = build(:user, password: 'Ｔest1234')
        user.valid?
        expect(user.errors[:password]).to include('is invalid')
      end
    end

    context '英小文字が全角の場合' do
      it '無効であること' do
        user = build(:user, password: 'Tｅｓｔ1234')
        user.valid?
        expect(user.errors[:password]).to include('is invalid')
      end
    end

    context '数字が全角の場合' do
      it '無効であること' do
        user = build(:user, password: 'Test１２３４')
        user.valid?
        expect(user.errors[:password]).to include('is invalid')
      end
    end

    context '7文字以下の場合' do
      it '無効であること' do
        user = build(:user, password: 'Test123')
        user.valid?
        expect(user.errors[:password]).to include('is too short (minimum is 8 characters)')
      end
    end

    context '17文字以上の場合' do
      it '無効であること' do
        user = build(:user, password: 'test1234567890abc')
        user.valid?
        expect(user.errors[:password]).to include('is too long (maximum is 16 characters)')
      end
    end
  end

  describe 'column: last_name' do
    context '重複した場合' do
      before do
        create(:user, last_name: '山田')
      end

      let(:user) { build(:user, last_name: '山田') }
      it_behaves_like '有効'
    end

    context '空の場合' do
      it '無効であること' do
        user = build(:user, last_name: '')
        user.valid?
        expect(user.errors[:last_name]).to include("can't be blank")
      end
    end
  end

  describe 'column: first_name' do
    context '重複した場合' do
      before do
        create(:user, first_name: '太郎')
      end

      let(:user) { build(:user, first_name: '太郎') }
      it_behaves_like '有効'
    end

    context '空の場合' do
      it '無効であること' do
        user = build(:user, first_name: '')
        user.valid?
        expect(user.errors[:first_name]).to include("can't be blank")
      end
    end
  end

  describe 'column: last_name_kana' do
    context '重複した場合' do
      before do
        create(:user, last_name_kana: 'やまだ')
      end

      let(:user) { build(:user, last_name_kana: 'やまだ') }
      it_behaves_like '有効'
    end

    context '空の場合' do
      it '無効であること' do
        user = build(:user, last_name_kana: '')
        user.valid?
        expect(user.errors[:last_name_kana]).to include("can't be blank")
      end
    end

    context '漢字の場合' do
      it '無効であること' do
        user = build(:user, last_name_kana: '山田')
        user.valid?
        expect(user.errors[:last_name_kana]).to include('is invalid')
      end
    end

    context 'カタカナの場合' do
      it '無効であること' do
        user = build(:user, last_name_kana: 'ヤマダ')
        user.valid?
        expect(user.errors[:last_name_kana]).to include('is invalid')
      end
    end

    context 'ローマ字の場合' do
      it '無効であること' do
        user = build(:user, last_name_kana: 'yamada')
        user.valid?
        expect(user.errors[:last_name_kana]).to include('is invalid')
      end
    end

    context '全てひらがなでない場合' do
      it '無効であること' do
        user = build(:user, last_name_kana: 'やま田')
        user.valid?
        expect(user.errors[:last_name_kana]).to include('is invalid')
      end
    end
  end

  describe 'colunm: last_name_kana' do
    context '重複した場合' do
      before do
        create(:user, first_name_kana: 'たろう')
      end

      let(:user) { build(:user, first_name_kana: 'たろう') }
      it_behaves_like '有効'
    end

    context '空の場合' do
      it '無効であること' do
        user = build(:user, first_name_kana: '')
        user.valid?
        expect(user.errors[:first_name_kana]).to include("can't be blank")
      end
    end

    context '漢字の場合' do
      it '無効であること' do
        user = build(:user, first_name_kana: '太郎')
        user.valid?
        expect(user.errors[:first_name_kana]).to include('is invalid')
      end
    end

    context 'カタカナの場合' do
      it '無効であること' do
        user = build(:user, first_name_kana: 'タロウ')
        user.valid?
        expect(user.errors[:first_name_kana]).to include('is invalid')
      end
    end

    context 'ローマ字の場合' do
      it '無効であること' do
        user = build(:user, first_name_kana: 'taro')
        user.valid?
        expect(user.errors[:first_name_kana]).to include('is invalid')
      end
    end

    context '全てひらがなでない場合' do
      it '無効であること' do
        user = build(:user, first_name_kana: 'た郎')
        user.valid?
        expect(user.errors[:first_name_kana]).to include('is invalid')
      end
    end
  end
end
