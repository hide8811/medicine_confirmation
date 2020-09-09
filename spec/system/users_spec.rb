require 'rails_helper'

RSpec.describe 'Users', type: :system do
  describe '新規登録', js: true do
    before do
      visit new_user_registration_path
    end
    context '全ての値が正しく入力されている時' do
      it 'メインページに遷移すること' do
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
      it 'エラーメッセージが出ること' do
        fill_in 'user[employee_id]', with: ''
        fill_in 'user[password]', with: 'Test1234'
        expect(page).to have_content '社員IDを入力してください'
      end

      it 'ページ遷移しないこと' do
        fill_in 'user[employee_id]', with: ''
        fill_in 'user[password]', with: 'Test1234'
        fill_in 'user[password_confirmation]', with: 'Test1234'
        fill_in 'user[last_name]', with: 'テスト'
        fill_in 'user[first_name]', with: 'ユーザー'
        fill_in 'user[last_name_kana]', with: 'てすと'
        fill_in 'user[first_name_kana]', with: 'ゆーざー'
        click_on '新規登録'
        expect(current_path).to eq new_user_registration_path
      end
    end

    # 追加・修正 予定-----------------------------------------------------
    context '社員IDがすでに使われているものである時' do
      before do
        create(:user, employee_id: 'ID1234')
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
    # ------------------------------------------------------------------------

    context 'パスワードが空の時' do
      it 'エラーメッセージが出ること' do
        fill_in 'user[password]', with: ''
        fill_in 'user[password_confirmation]', with: 'Test1234'
        expect(page).to have_content 'パスワードを入力してください'
      end

      it 'ページ遷移しないこと' do
        fill_in 'user[employee_id]', with: 'ID1234'
        fill_in 'user[password]', with: ''
        fill_in 'user[password_confirmation]', with: 'Test1234'
        fill_in 'user[last_name]', with: 'テスト'
        fill_in 'user[first_name]', with: 'ユーザー'
        fill_in 'user[last_name_kana]', with: 'てすと'
        fill_in 'user[first_name_kana]', with: 'ゆーざー'
        click_on '新規登録'
        expect(current_path).to eq new_user_registration_path
      end
    end

    context 'パスワードが8文字以下の時' do
      it 'エラーメッセージが出ること' do
        fill_in 'user[password]', with: 'Test12'
        fill_in 'user[password_confirmation]', with: 'Test1234'
        expect(page).to have_content '8文字以上で入力してください'
      end

      it 'ページ遷移しないこと' do
        fill_in 'user[employee_id]', with: 'ID1234'
        fill_in 'user[password]', with: 'Test12'
        fill_in 'user[password_confirmation]', with: 'Test1234'
        fill_in 'user[last_name]', with: 'テスト'
        fill_in 'user[first_name]', with: 'ユーザー'
        fill_in 'user[last_name_kana]', with: 'てすと'
        fill_in 'user[first_name_kana]', with: 'ゆーざー'
        click_on '新規登録'
        expect(current_path).to eq new_user_registration_path
      end
    end

    context 'パスワードが16文字以上の時' do
      it 'エラーメッセージが出ること' do
        fill_in 'user[password]', with: 'Test1234567890abcd'
        fill_in 'user[password_confirmation]', with: 'Test1234'
        expect(page).to have_content '16文字以下で入力してください'
      end

      it 'ページ遷移しないこと' do
        fill_in 'user[employee_id]', with: 'ID1234'
        fill_in 'user[password]', with: 'Test1234567890abcd'
        fill_in 'user[password_confirmation]', with: 'Test1234'
        fill_in 'user[last_name]', with: 'テスト'
        fill_in 'user[first_name]', with: 'ユーザー'
        fill_in 'user[last_name_kana]', with: 'てすと'
        fill_in 'user[first_name_kana]', with: 'ゆーざー'
        click_on '新規登録'
        expect(current_path).to eq new_user_registration_path
      end
    end

    # 追加・修正 予定 -----------------------------------------------------------------
    context 'パスワードに英大文字が入っていない時' do
      before do
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

    # ----------

    context 'パスワードに英小文字が入っていない時' do
      before do
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

    # --------------

    context 'パスワードに数字が入っていない時' do
      before do
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

    # ------------
    context 'パスワードに英大小数字以外が使われている時' do
      it 'エラーメッセージが出ること' do
      end

      it 'ページ遷移しないこと' do
      end
    end
    # --------------------------------------------------------------------

    context 'パスワード(確認)が空の時' do
      it 'エラーメッセージが出ること' do
        fill_in 'user[password_confirmation]', with: ''
        fill_in 'user[last_name]', with: 'テスト'
        expect(page).to have_content 'パスワード(確認)を入力してください'
      end

      it 'ページ遷移しないこと' do
        fill_in 'user[employee_id]', with: 'ID1234'
        fill_in 'user[password]', with: 'Test1234'
        fill_in 'user[password_confirmation]', with: ''
        fill_in 'user[last_name]', with: 'テスト'
        fill_in 'user[first_name]', with: 'ユーザー'
        fill_in 'user[last_name_kana]', with: 'てすと'
        fill_in 'user[first_name_kana]', with: 'ゆーざー'
        click_on '新規登録'
        expect(current_path).to eq new_user_registration_path
      end
    end

    # 追加・修正 予定 ------------------------------------------------------
    context 'パスワード(確認)がパスワードに入力した値と違う時' do
      before do
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
    # ----------------------------------------------------------------------

    context '名字が空の時' do
      it 'エラーメッセージが出ること' do
        fill_in 'user[last_name]', with: ''
        fill_in 'user[first_name]', with: 'ユーザー'
        expect(page).to have_content '名字を入力してください'
      end

      it 'ページ遷移しないこと' do
        fill_in 'user[employee_id]', with: 'ID1234'
        fill_in 'user[password]', with: 'Test1234'
        fill_in 'user[password_confirmation]', with: 'Test1234'
        fill_in 'user[last_name]', with: ''
        fill_in 'user[first_name]', with: 'ユーザー'
        fill_in 'user[last_name_kana]', with: 'てすと'
        fill_in 'user[first_name_kana]', with: 'ゆーざー'
        click_on '新規登録'
        expect(current_path).to eq new_user_registration_path
      end
    end

    context '名前が空の時' do
      it 'エラーメッセージが出ること' do
        fill_in 'user[first_name]', with: ''
        fill_in 'user[last_name_kana]', with: 'てすと'
        expect(page).to have_content '名前を入力してください'
      end

      it 'ページ遷移しないこと' do
        fill_in 'user[employee_id]', with: 'ID1234'
        fill_in 'user[password]', with: 'Test1234'
        fill_in 'user[password_confirmation]', with: 'Test1234'
        fill_in 'user[last_name]', with: 'テスト'
        fill_in 'user[first_name]', with: ''
        fill_in 'user[last_name_kana]', with: 'てすと'
        fill_in 'user[first_name_kana]', with: 'ゆーざー'
        click_on '新規登録'
        expect(current_path).to eq new_user_registration_path
      end
    end

    context 'みょうじが空の時' do
      it 'エラーメッセージが出ること' do
        fill_in 'user[last_name_kana]', with: ''
        fill_in 'user[first_name_kana]', with: 'ゆーざー'
        expect(page).to have_content 'みょうじを入力してください'
      end

      it 'ページ遷移しないこと' do
        fill_in 'user[employee_id]', with: 'ID1234'
        fill_in 'user[password]', with: 'Test1234'
        fill_in 'user[password_confirmation]', with: 'Test1234'
        fill_in 'user[last_name]', with: 'テスト'
        fill_in 'user[first_name]', with: 'ユーザー'
        fill_in 'user[last_name_kana]', with: ''
        fill_in 'user[first_name_kana]', with: 'ゆーざー'
        click_on '新規登録'
        expect(current_path).to eq new_user_registration_path
      end
    end

    # 追加・修正 予定 --------------------------------------------------------------
    context 'みょうじが漢字の時' do
      before do
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

    # -----------------------

    context 'みょうじがカタカナの時' do
      before do
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

    # ------------------------

    context 'みょうじが英字の時' do
      before do
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
    # ----------------------------------------------------------------------------------

    context 'なまえが空の時' do
      it 'エラーメッセージが出ること' do
        fill_in 'user[first_name_kana]', with: ''
        click_on '新規登録'
        expect(page).to have_content 'なまえを入力してください'
      end

      it 'ページ遷移しないこと' do
        fill_in 'user[employee_id]', with: 'ID1234'
        fill_in 'user[password]', with: 'Test1234'
        fill_in 'user[password_confirmation]', with: 'Test1234'
        fill_in 'user[last_name]', with: 'テスト'
        fill_in 'user[first_name]', with: 'ユーザー'
        fill_in 'user[last_name_kana]', with: 'てすと'
        fill_in 'user[first_name_kana]', with: ''
        click_on '新規登録'
        expect(current_path).to eq new_user_registration_path
      end
    end

    # 追加・修正 予定 ----------------------------------------------------------------------
    context 'なまえが漢字の時' do
      before do
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

    # ------------------

    context 'みょうじがカタカナの時' do
      before do
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

    # ------------------

    context 'なまえが英字の時' do
      before do
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

  # =======================================================================
  describe 'ログイン' do
    before do
      visit new_user_session_path
    end
    context '全ての値が正しく入力されている時' do
      it 'ログイン後、メインページに遷移すること' do
        user = create(:user)
        fill_in 'user[employee_id]', with: user.employee_id
        fill_in 'user[password]', with: user.password
        click_on 'ログイン'
        expect(current_path).to eq root_path
      end
    end

    # 追加・修正 予定 -------------------------------------------------------
    context '社員IDが入力されていない時' do
      before do
        user = create(:user)
        fill_in 'user[employee_id]', with: ''
        fill_in 'user[password]', with: user.password
        click_on 'ログイン'
      end

      it 'ログインできないこと' do
        expect(current_path).to eq new_user_session_path
      end
    end
    # ------------------------------------------------------------------------

    # 追加・修正 予定 -------------------------------------------------------
    context '社員IDが間違っている時' do
      before do
        user = create(:user, employee_id: 'id1234')
        fill_in 'user[employee_id]', with: 'test5678'
        fill_in 'user[password]', with: user.password
        click_on 'ログイン'
      end

      it 'ログインできないこと' do
        expect(current_path).to eq new_user_session_path
      end
    end
    # ------------------------------------------------------------------------

    # 追加・修正 予定 -------------------------------------------------------
    context 'パスワードが入力されていない時' do
      before do
        user = create(:user)
        fill_in 'user[employee_id]', with: user.employee_id
        fill_in 'user[password]', with: ''
        click_on 'ログイン'
      end

      it 'ログインできないこと' do
        expect(current_path).to eq new_user_session_path
      end
    end
    # --------------------------------------------------------------------------

    # 追加・修正 予定 -------------------------------------------------------
    context 'パスワードが間違っている時' do
      before do
        user = create(:user, password: 'Test1234')
        fill_in 'user[employee_id]', with: user.employee_id
        fill_in 'user[password]', with: 'user5678'
        click_on 'ログイン'
      end

      it 'ログインできないこと' do
        expect(current_path).to eq new_user_session_path
      end
    end
    # --------------------------------------------------------------------------
  end
end
