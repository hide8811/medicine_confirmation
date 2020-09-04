require 'rails_helper'

RSpec.describe 'Users', type: :system do
  describe '新規登録' do
    context '全ての値が正しく入力されている時' do
      it 'メインページに遷移すること' do
        visit new_user_registration_path
        fill_in 'user[employee_id]', with: 'ID1234'
        fill_in 'user[password]', with: 'Test1234'
        fill_in 'user[password_confirmation]', with: 'Test1234'
        fill_in 'user[last_name]', with: 'テスト'
        fill_in 'user[first_name]', with: 'ユーザー'
        fill_in 'user[last_name_kana]', with: 'てすと'
        fill_in 'user[first_name_kana]', with: 'ゆーざー'
        click_on '新規登録'
        expect(current_path).to eq root_path
      end
    end

    context '社員IDが空の時' do
      before do
        visit new_user_registration_path
        fill_in 'user[employee_id]', with: ''
        fill_in 'user[password]', with: 'Test1234'
        fill_in 'user[password_confirmation]', with: 'Test1234'
        fill_in 'user[last_name]', with: 'テスト'
        fill_in 'user[first_name]', with: 'ユーザー'
        fill_in 'user[last_name_kana]', with: 'てすと'
        fill_in 'user[first_name_kana]', with: 'ゆーざー'
        click_on '新規登録'
      end

      it 'ページ遷移しないこと' do
        expect(current_path).to eq user_registration_path
      end
    end

    context '社員IDがすでに使われているものである時' do
      before do
        create(:user, employee_id: 'ID1234')
        visit new_user_registration_path
        fill_in 'user[employee_id]', with: 'ID1234'
        fill_in 'user[password]', with: 'Test1234'
        fill_in 'user[password_confirmation]', with: 'Test1234'
        fill_in 'user[last_name]', with: 'テスト'
        fill_in 'user[first_name]', with: 'ユーザー'
        fill_in 'user[last_name_kana]', with: 'てすと'
        fill_in 'user[first_name_kana]', with: 'ゆーざー'
        click_on '新規登録'
      end

      it 'ページ遷移しないこと' do
        expect(current_path).to eq user_registration_path
      end
    end

    context 'パスワードが空の時' do
      before do
        visit new_user_registration_path
        fill_in 'user[employee_id]', with: 'ID1234'
        fill_in 'user[password]', with: ''
        fill_in 'user[password_confirmation]', with: 'Test1234'
        fill_in 'user[last_name]', with: 'テスト'
        fill_in 'user[first_name]', with: 'ユーザー'
        fill_in 'user[last_name_kana]', with: 'てすと'
        fill_in 'user[first_name_kana]', with: 'ゆーざー'
        click_on '新規登録'
      end

      it 'ページ遷移しないこと' do
        expect(current_path).to eq user_registration_path
      end
    end

    context 'パスワードが8文字以下の時' do
      before do
        visit new_user_registration_path
        fill_in 'user[employee_id]', with: 'ID1234'
        fill_in 'user[password]', with: 'Test12'
        fill_in 'user[password_confirmation]', with: 'Test1234'
        fill_in 'user[last_name]', with: 'テスト'
        fill_in 'user[first_name]', with: 'ユーザー'
        fill_in 'user[last_name_kana]', with: 'てすと'
        fill_in 'user[first_name_kana]', with: 'ゆーざー'
        click_on '新規登録'
      end

      it 'ページ遷移しないこと' do
        expect(current_path).to eq user_registration_path
      end
    end

    context 'パスワードが16文字以上の時' do
      before do
        visit new_user_registration_path
        fill_in 'user[employee_id]', with: 'ID1234'
        fill_in 'user[password]', with: 'Test1234567890abcd'
        fill_in 'user[password_confirmation]', with: 'Test1234'
        fill_in 'user[last_name]', with: 'テスト'
        fill_in 'user[first_name]', with: 'ユーザー'
        fill_in 'user[last_name_kana]', with: 'てすと'
        fill_in 'user[first_name_kana]', with: 'ゆーざー'
        click_on '新規登録'
      end

      it 'ページ遷移しないこと' do
        expect(current_path).to eq user_registration_path
      end
    end

    context 'パスワードに英大文字が入っていない時' do
      before do
        visit new_user_registration_path
        fill_in 'user[employee_id]', with: 'ID1234'
        fill_in 'user[password]', with: 'test1234'
        fill_in 'user[password_confirmation]', with: 'Test1234'
        fill_in 'user[last_name]', with: 'テスト'
        fill_in 'user[first_name]', with: 'ユーザー'
        fill_in 'user[last_name_kana]', with: 'てすと'
        fill_in 'user[first_name_kana]', with: 'ゆーざー'
        click_on '新規登録'
      end

      it 'ページ遷移しないこと' do
        expect(current_path).to eq user_registration_path
      end
    end

    context 'パスワードに英小文字が入っていない時' do
      before do
        visit new_user_registration_path
        fill_in 'user[employee_id]', with: 'ID1234'
        fill_in 'user[password]', with: 'TEST1234'
        fill_in 'user[password_confirmation]', with: 'Test1234'
        fill_in 'user[last_name]', with: 'テスト'
        fill_in 'user[first_name]', with: 'ユーザー'
        fill_in 'user[last_name_kana]', with: 'てすと'
        fill_in 'user[first_name_kana]', with: 'ゆーざー'
        click_on '新規登録'
      end

      it 'ページ遷移しないこと' do
        expect(current_path).to eq user_registration_path
      end
    end

    context 'パスワードに数字が入っていない時' do
      before do
        visit new_user_registration_path
        fill_in 'user[employee_id]', with: 'ID1234'
        fill_in 'user[password]', with: 'TestTest'
        fill_in 'user[password_confirmation]', with: 'Test1234'
        fill_in 'user[last_name]', with: 'テスト'
        fill_in 'user[first_name]', with: 'ユーザー'
        fill_in 'user[last_name_kana]', with: 'てすと'
        fill_in 'user[first_name_kana]', with: 'ゆーざー'
        click_on '新規登録'
      end

      it 'ページ遷移しないこと' do
        expect(current_path).to eq user_registration_path
      end
    end

    context 'パスワード(確認)が空の時' do
      before do
        visit new_user_registration_path
        fill_in 'user[employee_id]', with: 'ID1234'
        fill_in 'user[password]', with: 'Test1234'
        fill_in 'user[password_confirmation]', with: ''
        fill_in 'user[last_name]', with: 'テスト'
        fill_in 'user[first_name]', with: 'ユーザー'
        fill_in 'user[last_name_kana]', with: 'てすと'
        fill_in 'user[first_name_kana]', with: 'ゆーざー'
        click_on '新規登録'
      end

      it 'ページ遷移しないこと' do
        expect(current_path).to eq user_registration_path
      end
    end

    context 'パスワード(確認)がパスワードに入力した値と違う時' do
      before do
        visit new_user_registration_path
        fill_in 'user[employee_id]', with: 'ID1234'
        fill_in 'user[password]', with: 'Test1234'
        fill_in 'user[password_confirmation]', with: 'User1234'
        fill_in 'user[last_name]', with: 'テスト'
        fill_in 'user[first_name]', with: 'ユーザー'
        fill_in 'user[last_name_kana]', with: 'てすと'
        fill_in 'user[first_name_kana]', with: 'ゆーざー'
        click_on '新規登録'
      end

      it 'ページ遷移しないこと' do
        expect(current_path).to eq user_registration_path
      end
    end

    context '姓が空の時' do
      before do
        visit new_user_registration_path
        fill_in 'user[employee_id]', with: 'ID1234'
        fill_in 'user[password]', with: 'Test1234'
        fill_in 'user[password_confirmation]', with: 'Test1234'
        fill_in 'user[last_name]', with: ''
        fill_in 'user[first_name]', with: 'ユーザー'
        fill_in 'user[last_name_kana]', with: 'てすと'
        fill_in 'user[first_name_kana]', with: 'ゆーざー'
        click_on '新規登録'
      end

      it 'ページ遷移しないこと' do
        expect(current_path).to eq user_registration_path
      end
    end

    context '名が空の時' do
      before do
        visit new_user_registration_path
        fill_in 'user[employee_id]', with: 'ID1234'
        fill_in 'user[password]', with: 'Test1234'
        fill_in 'user[password_confirmation]', with: 'Test1234'
        fill_in 'user[last_name]', with: 'テスト'
        fill_in 'user[first_name]', with: ''
        fill_in 'user[last_name_kana]', with: 'てすと'
        fill_in 'user[first_name_kana]', with: 'ゆーざー'
        click_on '新規登録'
      end

      it 'ページ遷移しないこと' do
        expect(current_path).to eq user_registration_path
      end
    end

    context 'みょうじが空の時' do
      before do
        visit new_user_registration_path
        fill_in 'user[employee_id]', with: 'ID1234'
        fill_in 'user[password]', with: 'Test1234'
        fill_in 'user[password_confirmation]', with: 'Test1234'
        fill_in 'user[last_name]', with: 'テスト'
        fill_in 'user[first_name]', with: 'ユーザー'
        fill_in 'user[last_name_kana]', with: ''
        fill_in 'user[first_name_kana]', with: 'ゆーざー'
        click_on '新規登録'
      end

      it 'ページ遷移しないこと' do
        expect(current_path).to eq user_registration_path
      end
    end

    context 'みょうじが漢字の時' do
      before do
        visit new_user_registration_path
        fill_in 'user[employee_id]', with: 'ID1234'
        fill_in 'user[password]', with: 'Test1234'
        fill_in 'user[password_confirmation]', with: 'Test1234'
        fill_in 'user[last_name]', with: 'テスト'
        fill_in 'user[first_name]', with: 'ユーザー'
        fill_in 'user[last_name_kana]', with: '試験'
        fill_in 'user[first_name_kana]', with: 'ゆーざー'
        click_on '新規登録'
      end

      it 'ページ遷移しないこと' do
        expect(current_path).to eq user_registration_path
      end
    end

    context 'みょうじがカタカナの時' do
      before do
        visit new_user_registration_path
        fill_in 'user[employee_id]', with: 'ID1234'
        fill_in 'user[password]', with: 'Test1234'
        fill_in 'user[password_confirmation]', with: 'Test1234'
        fill_in 'user[last_name]', with: 'テスト'
        fill_in 'user[first_name]', with: 'ユーザー'
        fill_in 'user[last_name_kana]', with: 'テスト'
        fill_in 'user[first_name_kana]', with: 'ゆーざー'
        click_on '新規登録'
      end

      it 'ページ遷移しないこと' do
        expect(current_path).to eq user_registration_path
      end
    end

    context 'みょうじが英字の時' do
      before do
        visit new_user_registration_path
        fill_in 'user[employee_id]', with: 'ID1234'
        fill_in 'user[password]', with: 'Test1234'
        fill_in 'user[password_confirmation]', with: 'Test1234'
        fill_in 'user[last_name]', with: 'テスト'
        fill_in 'user[first_name]', with: 'ユーザー'
        fill_in 'user[last_name_kana]', with: 'test'
        fill_in 'user[first_name_kana]', with: 'ゆーざー'
        click_on '新規登録'
      end

      it 'ページ遷移しないこと' do
        expect(current_path).to eq user_registration_path
      end
    end

    context 'なまえが空の時' do
      before do
        visit new_user_registration_path
        fill_in 'user[employee_id]', with: 'ID1234'
        fill_in 'user[password]', with: 'Test1234'
        fill_in 'user[password_confirmation]', with: 'Test1234'
        fill_in 'user[last_name]', with: 'テスト'
        fill_in 'user[first_name]', with: 'ユーザー'
        fill_in 'user[last_name_kana]', with: 'てすと'
        fill_in 'user[first_name_kana]', with: ''
        click_on '新規登録'
      end

      it 'ページ遷移しないこと' do
        expect(current_path).to eq user_registration_path
      end
    end

    context 'なまえが漢字の時' do
      before do
        visit new_user_registration_path
        fill_in 'user[employee_id]', with: 'ID1234'
        fill_in 'user[password]', with: 'Test1234'
        fill_in 'user[password_confirmation]', with: 'Test1234'
        fill_in 'user[last_name]', with: 'テスト'
        fill_in 'user[first_name]', with: 'ユーザー'
        fill_in 'user[last_name_kana]', with: 'てすと'
        fill_in 'user[first_name_kana]', with: '利用者'
        click_on '新規登録'
      end

      it 'ページ遷移しないこと' do
        expect(current_path).to eq user_registration_path
      end
    end

    context 'みょうじがカタカナの時' do
      before do
        visit new_user_registration_path
        fill_in 'user[employee_id]', with: 'ID1234'
        fill_in 'user[password]', with: 'Test1234'
        fill_in 'user[password_confirmation]', with: 'Test1234'
        fill_in 'user[last_name]', with: 'テスト'
        fill_in 'user[first_name]', with: 'ユーザー'
        fill_in 'user[last_name_kana]', with: 'てすと'
        fill_in 'user[first_name_kana]', with: 'ユーザー'
        click_on '新規登録'
      end

      it 'ページ遷移しないこと' do
        expect(current_path).to eq user_registration_path
      end
    end

    context 'なまえが英字の時' do
      before do
        visit new_user_registration_path
        fill_in 'user[employee_id]', with: 'ID1234'
        fill_in 'user[password]', with: 'Test1234'
        fill_in 'user[password_confirmation]', with: 'Test1234'
        fill_in 'user[last_name]', with: 'テスト'
        fill_in 'user[first_name]', with: 'ユーザー'
        fill_in 'user[last_name_kana]', with: 'てすと'
        fill_in 'user[first_name_kana]', with: 'user'
        click_on '新規登録'
      end

      it 'ページ遷移しないこと' do
        expect(current_path).to eq user_registration_path
      end
    end
  end
end
