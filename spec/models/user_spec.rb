require 'rails_helper'

RSpec.describe User, type: :model do
  context '有効であること' do
    it '社員ID・パスワード・姓・名・姓(かな)・名(かな) がある場合、有効であること' do
      user = build(:user)
      expect(user).to be_valid
    end

    it 'パスワード に 英大文字・英小文字・数字 がそれぞれ1文字以上あり、文字数 が 8文字以上16文字以下 の場合、有効であること' do
      user = build(:user, password: 'TEst1234')
      expect(user).to be_valid
    end

    it 'パスワード の 英大文字・英小文字・数字 が順不同でも、有効であること' do
      user = build(:user, password: '1te23St4')
      expect(user).to be_valid
    end

    it '姓 が重複した場合、有効であること' do
      create(:user, last_name: '山田')
      user = build(:user, last_name: '山田')
      expect(user).to be_valid
    end

    it '名 が重複した場合、有効であること' do
      create(:user, first_name: '太郎')
      user = build(:user, first_name: '太郎')
      expect(user).to be_valid
    end

    it '姓(かな) が重複した場合、有効であること' do
      create(:user, last_name_kana: 'やまだ')
      user = build(:user, last_name_kana: 'やまだ')
      expect(user).to be_valid
    end

    it '名(かな) が重複した場合、有効であること' do
      create(:user, first_name_kana: 'たろう')
      user = build(:user, first_name_kana: 'たろう')
      expect(user).to be_valid
    end
  end

  context '無効であること' do
    it '社員ID がない場合、無効であること' do
      user = build(:user, employee_id: '')
      user.valid?
      expect(user.errors[:employee_id]).to include("can't be blank")
    end

    it '社員ID が重複した場合、無効であること' do
      create(:user, employee_id: 'id12345')
      user = build(:user, employee_id: 'id12345')
      user.valid?
      expect(user.errors[:employee_id]).to include('has already been taken')
    end

    it 'パスワード がない場合、無効であること' do
      user = build(:user, password: '')
      user.valid?
      expect(user.errors[:password]).to include("can't be blank")
    end

    it 'パスワード に 半角英大文字 がない場合、無効であること' do
      user = build(:user, password: 'test1234')
      user.valid?
      expect(user.errors[:password]).to include('is invalid')
    end

    it 'パスワード に 半角英小文字 がない場合、無効であること' do
      user = build(:user, password: 'TEST1234')
      user.valid?
      expect(user.errors[:password]).to include('is invalid')
    end

    it 'パスワード に 半角数字 がない場合、無効であること' do
      user = build(:user, password: 'TestTest')
      user.valid?
      expect(user.errors[:password]).to include('is invalid')
    end

    it 'パスワード に 全角英大文字 がある場合、無効であること' do
      user = build(:user, password: 'Ｔest1234')
      user.valid?
      expect(user.errors[:password]).to include('is invalid')
    end

    it 'パスワード に 全角英小文字 がある場合、無効であること' do
      user = build(:user, password: 'Tｅｓｔ1234')
      user.valid?
      expect(user.errors[:password]).to include('is invalid')
    end

    it 'パスワード に 全角数字 がある場合、無効であること' do
      user = build(:user, password: 'Test１２３４')
      user.valid?
      expect(user.errors[:password]).to include('is invalid')
    end

    it 'パスワード が 7文字以下 の場合、無効であること' do
      user = build(:user, password: 'Test123')
      user.valid?
      expect(user.errors[:password]).to include('is too short (minimum is 8 characters)')
    end

    it 'パスワード が 17文字以上 の場合、無効であること' do
      user = build(:user, password: 'test1234567890abc')
      user.valid?
      expect(user.errors[:password]).to include('is too long (maximum is 16 characters)')
    end

    it '姓 がない場合、無効であること' do
      user = build(:user, last_name: '')
      user.valid?
      expect(user.errors[:last_name]).to include("can't be blank")
    end

    it '名 がない場合、無効であること' do
      user = build(:user, first_name: '')
      user.valid?
      expect(user.errors[:first_name]).to include("can't be blank")
    end

    it '姓(かな) がない場合、無効であること' do
      user = build(:user, last_name_kana: '')
      user.valid?
      expect(user.errors[:last_name_kana]).to include("can't be blank")
    end

    it '姓(かな) が 漢字 の場合、無効であること' do
      user = build(:user, last_name_kana: '山田')
      user.valid?
      expect(user.errors[:last_name_kana]).to include('is invalid')
    end

    it '姓(かな) が カタカナ の場合、無効であること' do
      user = build(:user, last_name_kana: 'ヤマダ')
      user.valid?
      expect(user.errors[:last_name_kana]).to include('is invalid')
    end

    it '姓(かな) が ローマ字 の場合、無効であること' do
      user = build(:user, last_name_kana: 'yamada')
      user.valid?
      expect(user.errors[:last_name_kana]).to include('is invalid')
    end

    it '姓(かな) が全て平仮名でない場合、無効であること' do
      user = build(:user, last_name_kana: 'やま田')
      user.valid?
      expect(user.errors[:last_name_kana]).to include('is invalid')
    end

    it '名(かな) がない場合、無効であること' do
      user = build(:user, first_name_kana: '')
      user.valid?
      expect(user.errors[:first_name_kana]).to include("can't be blank")
    end

    it '名(かな) が 漢字 の場合、無効であること' do
      user = build(:user, first_name_kana: '太郎')
      user.valid?
      expect(user.errors[:first_name_kana]).to include('is invalid')
    end

    it '名(かな) が カタカナ の場合、無効であること' do
      user = build(:user, first_name_kana: 'タロウ')
      user.valid?
      expect(user.errors[:first_name_kana]).to include('is invalid')
    end

    it '名(かな) が ローマ字 の場合、無効であること' do
      user = build(:user, first_name_kana: 'taro')
      user.valid?
      expect(user.errors[:first_name_kana]).to include('is invalid')
    end

    it '名(かな) が全て平仮名でない場合、無効であること' do
      user = build(:user, first_name_kana: 'た郎')
      user.valid?
      expect(user.errors[:first_name_kana]).to include('is invalid')
    end
  end
end
