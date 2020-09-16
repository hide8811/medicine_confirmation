require 'rails_helper'

RSpec.describe 'Users', type: :system do
  describe '新規登録', js: true do
    before do
      visit new_user_registration_path
    end

    it 'フォーム内でEnterキーを押した時、submitされないこと' do
      fill_in 'user[employee_id]', with: 'ID1234'
      fill_in 'user[password]', with: 'Test1234'
      fill_in 'user[password_confirmation]', with: 'Test1234'
      fill_in 'user[last_name]', with: 'テスト'
      fill_in 'user[first_name]', with: 'ユーザー'
      fill_in 'user[last_name_kana]', with: 'てすと'
      fill_in 'user[first_name_kana]', with: 'ゆーざー'
      find('#user-last-name-kana').send_keys(:enter)
      expect(current_path).not_to eq root_path
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
      it 'フォーカスが外れると、エラーメッセージが出ること' do
        fill_in 'user[employee_id]', with: ''
        find('#user-password').click
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

      it '値を入力し、フォーカスが外れると、エラーメッセージが消えること' do
        fill_in 'user[employee_id]', with: ''
        find('#user-password').click
        fill_in 'user[employee_id]', with: 'ID1234'
        find('#user-password').click
        expect(page).not_to have_content '社員IDを入力してください'
      end
    end

    context '社員IDがすでに使われているものである時' do
      before do
        create(:user, employee_id: 'ID1234')
      end

      it 'フォーカスが外れると、エラーメッセージが出ること' do
        fill_in 'user[employee_id]', with: 'ID1234'
        find('#user-password').click
        expect(page).to have_content 'その社員IDはすでに使用されています'
      end

      it 'ページ遷移しないこと' do
        fill_in 'user[employee_id]', with: 'ID1234'
        fill_in 'user[password]', with: 'Test1234'
        fill_in 'user[password_confirmation]', with: 'Test1234'
        fill_in 'user[last_name]', with: 'テスト'
        fill_in 'user[first_name]', with: 'ユーザー'
        fill_in 'user[last_name_kana]', with: 'てすと'
        fill_in 'user[first_name_kana]', with: 'ゆーざー'
        click_on '新規登録'
        expect(current_path).to eq new_user_registration_path
      end

      it '正しい値を入力し、フォーカスが外れると、エラーメッセージが消えること' do
        fill_in 'user[employee_id]', with: 'ID1234'
        find('#user-password').click
        fill_in 'user[employee_id]', with: 'User5678'
        find('#user-password').click
        expect(page).not_to have_content 'その社員IDはすでに使用されています'
      end
    end

    context 'パスワードが空の時' do
      it 'フォーカスが外れると、エラーメッセージが出ること' do
        fill_in 'user[password]', with: ''
        find('#user-confirmation-password').click
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

      it '値を入力し、フォーカスが外れると、エラーメッセージが消えること' do
        fill_in 'user[password]', with: ''
        find('#user-confirmation-password').click
        fill_in 'user[password]', with: 'Test1234'
        find('#user-confirmation-password').click
        expect(page).not_to have_content 'パスワードを入力してください'
      end
    end

    context 'パスワードが8文字以下の時' do
      it 'フォーカスが外れると、エラーメッセージが出ること' do
        fill_in 'user[password]', with: 'Test12'
        find('#user-confirmation-password').click
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

      it '正しい値を入力し、フォーカスが外れると、エラーメッセージが消えること' do
        fill_in 'user[password]', with: 'Test12'
        find('#user-confirmation-password').click
        fill_in 'user[password]', with: 'Test1234'
        find('#user-confirmation-password').click
        expect(page).not_to have_content '8文字以上で入力してください'
      end
    end

    context 'パスワードが16文字以上の時' do
      it 'フォーカスが外れると、エラーメッセージが出ること' do
        fill_in 'user[password]', with: 'Test1234567890abcd'
        find('#user-confirmation-password').click
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

      it '正しい値を入力し、フォーカスが外れると、エラーメッセージが消えること' do
        fill_in 'user[password]', with: 'Test1234567890abcd'
        find('#user-confirmation-password').click
        fill_in 'user[password]', with: 'Test1234'
        find('#user-confirmation-password').click
        expect(page).not_to have_content '16文字以下で入力してください'
      end
    end

    context 'パスワードに英大小数字以外が使われている時' do
      it 'フォーカスが外れると、エラーメッセージが出ること' do
        fill_in 'user[password]', with: '%test@1234&'
        find('#user-confirmation-password').click
        expect(page).to have_content '半角英数字以外は使用できません'
      end

      it 'ページ遷移しないこと' do
        fill_in 'user[employee_id]', with: 'ID1234'
        fill_in 'user[password]', with: '%test@1234&'
        fill_in 'user[password_confirmation]', with: 'Test1234'
        fill_in 'user[last_name]', with: 'テスト'
        fill_in 'user[first_name]', with: 'ユーザー'
        fill_in 'user[last_name_kana]', with: 'てすと'
        fill_in 'user[first_name_kana]', with: 'ゆーざー'
        click_on '新規登録'
        expect(current_path).to eq new_user_registration_path
      end

      it '正しい値を入力し、フォーカスが外れると、エラーメッセージが消えること' do
        fill_in 'user[password]', with: '%test@1234&'
        find('#user-confirmation-password').click
        fill_in 'user[password]', with: 'test1234'
        find('#user-confirmation-password').click
        expect(page).not_to have_content '半角英数字以外は使用できません'
      end
    end

    context 'パスワードに英大文字が入っていない時' do
      it 'フォーカスが外れると、エラーメッセージが出ること' do
        fill_in 'user[password]', with: 'test1234'
        find('#user-confirmation-password').click
        expect(page).to have_content '"英大文字"を含めてください'
      end

      it 'ページ遷移しないこと' do
        fill_in 'user[employee_id]', with: 'ID1234'
        fill_in 'user[password]', with: 'test1234'
        fill_in 'user[password_confirmation]', with: 'Test1234'
        fill_in 'user[last_name]', with: 'テスト'
        fill_in 'user[first_name]', with: 'ユーザー'
        fill_in 'user[last_name_kana]', with: 'てすと'
        fill_in 'user[first_name_kana]', with: 'ゆーざー'
        click_on '新規登録'
        expect(current_path).to eq new_user_registration_path
      end

      it '正しい値を入力し、フォーカスが外れると、エラーメッセージが消えること' do
        fill_in 'user[password]', with: 'test1234'
        find('#user-confirmation-password').click
        fill_in 'user[password]', with: 'Test1234'
        find('#user-confirmation-password').click
        expect(page).not_to have_content '"英大文字"を含めてください'
      end
    end

    context 'パスワードに英小文字が入っていない時' do
      it 'フォーカスが外れると、エラーメッセージが出ること' do
        fill_in 'user[password]', with: 'TEST1234'
        find('#user-confirmation-password').click
        expect(page).to have_content '"英小文字"を含めてください'
      end

      it 'ページ遷移しないこと' do
        fill_in 'user[employee_id]', with: 'ID1234'
        fill_in 'user[password]', with: 'TEST1234'
        fill_in 'user[password_confirmation]', with: 'Test1234'
        fill_in 'user[last_name]', with: 'テスト'
        fill_in 'user[first_name]', with: 'ユーザー'
        fill_in 'user[last_name_kana]', with: 'てすと'
        fill_in 'user[first_name_kana]', with: 'ゆーざー'
        click_on '新規登録'
        expect(current_path).to eq new_user_registration_path
      end

      it '正しい値を入力し、フォーカスが外れると、エラーメッセージが消えること' do
        fill_in 'user[password]', with: 'TEST1234'
        find('#user-confirmation-password').click
        fill_in 'user[password]', with: 'Test1234'
        find('#user-confirmation-password').click
        expect(page).not_to have_content '"英小文字"を含めてください'
      end
    end

    context 'パスワードに数字が入っていない時' do
      it 'フォーカスが外れると、エラーメッセージが出ること' do
        fill_in 'user[password]', with: 'TestTest'
        find('#user-confirmation-password').click
        expect(page).to have_content '"数字"を含めてください'
      end

      it 'ページ遷移しないこと' do
        fill_in 'user[employee_id]', with: 'ID1234'
        fill_in 'user[password]', with: 'TestTest'
        fill_in 'user[password_confirmation]', with: 'Test1234'
        fill_in 'user[last_name]', with: 'テスト'
        fill_in 'user[first_name]', with: 'ユーザー'
        fill_in 'user[last_name_kana]', with: 'てすと'
        fill_in 'user[first_name_kana]', with: 'ゆーざー'
        click_on '新規登録'
        expect(current_path).to eq new_user_registration_path
      end

      it '正しい値を入力し、フォーカスが外れると、エラーメッセージが消えること' do
        fill_in 'user[password]', with: 'TestTest'
        find('#user-confirmation-password').click
        fill_in 'user[password]', with: 'Test1234'
        find('#user-confirmation-password').click
        expect(page).not_to have_content '"英小文字"を含めてください'
      end
    end

    context 'パスワード(確認)が空の時' do
      it 'フォーカスが外れると、エラーメッセージが出ること' do
        fill_in 'user[password_confirmation]', with: ''
        find('#user-last-name').click
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

      it '値を入力し、フォーカスが外れると、エラーメッセージが消えること' do
        fill_in 'user[password_confirmation]', with: ''
        find('#user-last-name').click
        fill_in 'user[password_confirmation]', with: 'Test1234'
        find('#user-last-name').click
        expect(page).not_to have_content 'パスワード(確認)を入力してください'
      end
    end

    context 'パスワード(確認)がパスワードに入力した値と違う時' do
      it 'フォーカスが外れると、エラーメッセージが出ること' do
        fill_in 'user[password]', with: 'Test1234'
        fill_in 'user[password_confirmation]', with: 'User1234'
        find('#user-last-name').click
        expect(page).to have_content 'パスワードを確認してください'
      end

      it 'ページ遷移しないこと' do
        fill_in 'user[employee_id]', with: 'ID1234'
        fill_in 'user[password]', with: 'Test1234'
        fill_in 'user[password_confirmation]', with: 'User1234'
        fill_in 'user[last_name]', with: 'テスト'
        fill_in 'user[first_name]', with: 'ユーザー'
        fill_in 'user[last_name_kana]', with: 'てすと'
        fill_in 'user[first_name_kana]', with: 'ゆーざー'
        click_on '新規登録'
        expect(current_path).to eq new_user_registration_path
      end

      it 'フォーカスが外れると、エラーメッセージが出ること' do
        fill_in 'user[password]', with: 'Test1234'
        fill_in 'user[password_confirmation]', with: 'User1234'
        find('#user-last-name').click
        fill_in 'user[password_confirmation]', with: 'Test1234'
        find('#user-last-name').click
        expect(page).not_to have_content 'パスワードを確認してください'
      end
    end

    context '名字が空の時' do
      it 'フォーカスが外れると、エラーメッセージが出ること' do
        fill_in 'user[last_name]', with: ''
        find('#user-first-name').click
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

      it '値を入力し、フォーカスが外れると、エラーメッセージが消えること' do
        fill_in 'user[last_name]', with: ''
        find('#user-first-name').click
        fill_in 'user[last_name]', with: 'テスト'
        find('#user-first-name').click
        expect(page).not_to have_content '名字を入力してください'
      end
    end

    context '名前が空の時' do
      it 'フォーカスが外れると、エラーメッセージが出ること' do
        fill_in 'user[first_name]', with: ''
        find('#user-last-name-kana').click
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

      it '値を入力し、フォーカスが外れると、エラーメッセージが消えること' do
        fill_in 'user[first_name]', with: ''
        find('#user-last-name-kana').click
        fill_in 'user[first_name]', with: 'ユーザー'
        find('#user-last-name-kana').click
        expect(page).not_to have_content '名前を入力してください'
      end
    end

    context 'みょうじが空の時' do
      it 'フォーカスが外れると、エラーメッセージが出ること' do
        fill_in 'user[last_name_kana]', with: ''
        find('#user-first-name-kana').click
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

      it '値を入力し、フォーカスが外れると、エラーメッセージが消えること' do
        fill_in 'user[last_name_kana]', with: ''
        find('#user-first-name-kana').click
        fill_in 'user[last_name_kana]', with: 'てすと'
        find('#user-first-name-kana').click
        expect(page).not_to have_content 'みょうじを入力してください'
      end
    end

    context 'みょうじが漢字の時' do
      it 'フォーカスが外れると、エラーメッセージが出ること' do
        fill_in 'user[last_name_kana]', with: '試験'
        find('#user-first-name-kana').click
        expect(page).to have_content 'みょうじはひらがなで入力してください'
      end

      it 'ページ遷移しないこと' do
        fill_in 'user[employee_id]', with: 'ID1234'
        fill_in 'user[password]', with: 'Test1234'
        fill_in 'user[password_confirmation]', with: 'Test1234'
        fill_in 'user[last_name]', with: 'テスト'
        fill_in 'user[first_name]', with: 'ユーザー'
        fill_in 'user[last_name_kana]', with: '試験'
        fill_in 'user[first_name_kana]', with: 'ゆーざー'
        click_on '新規登録'
        expect(current_path).to eq new_user_registration_path
      end

      it '値を入力し、フォーカスが外れると、エラーメッセージが消えること' do
        fill_in 'user[last_name_kana]', with: '試験'
        find('#user-first-name-kana').click
        fill_in 'user[last_name_kana]', with: 'てすと'
        find('#user-first-name-kana').click
        expect(page).not_to have_content 'みょうじはひらがなで入力してください'
      end
    end

    context 'みょうじがカタカナの時' do
      it 'フォーカスが外れると、エラーメッセージが出ること' do
        fill_in 'user[last_name_kana]', with: 'テスト'
        find('#user-first-name-kana').click
        expect(page).to have_content 'みょうじはひらがなで入力してください'
      end

      it 'ページ遷移しないこと' do
        fill_in 'user[employee_id]', with: 'ID1234'
        fill_in 'user[password]', with: 'Test1234'
        fill_in 'user[password_confirmation]', with: 'Test1234'
        fill_in 'user[last_name]', with: 'テスト'
        fill_in 'user[first_name]', with: 'ユーザー'
        fill_in 'user[last_name_kana]', with: 'テスト'
        fill_in 'user[first_name_kana]', with: 'ゆーざー'
        click_on '新規登録'
        expect(current_path).to eq new_user_registration_path
      end

      it '値を入力し、フォーカスが外れると、エラーメッセージが消えること' do
        fill_in 'user[last_name_kana]', with: 'テスト'
        find('#user-first-name-kana').click
        fill_in 'user[last_name_kana]', with: 'てすと'
        find('#user-first-name-kana').click
        expect(page).not_to have_content 'みょうじはひらがなで入力してください'
      end
    end

    context 'みょうじが英字の時' do
      it 'フォーカスが外れると、エラーメッセージが出ること' do
        fill_in 'user[last_name_kana]', with: 'test'
        find('#user-first-name-kana').click
        expect(page).to have_content 'みょうじはひらがなで入力してください'
      end

      it 'ページ遷移しないこと' do
        fill_in 'user[employee_id]', with: 'ID1234'
        fill_in 'user[password]', with: 'Test1234'
        fill_in 'user[password_confirmation]', with: 'Test1234'
        fill_in 'user[last_name]', with: 'テスト'
        fill_in 'user[first_name]', with: 'ユーザー'
        fill_in 'user[last_name_kana]', with: 'test'
        fill_in 'user[first_name_kana]', with: 'ゆーざー'
        click_on '新規登録'
        expect(current_path).to eq new_user_registration_path
      end

      it '値を入力し、フォーカスが外れると、エラーメッセージが消えること' do
        fill_in 'user[last_name_kana]', with: 'test'
        find('#user-first-name-kana').click
        fill_in 'user[last_name_kana]', with: 'てすと'
        find('#user-first-name-kana').click
        expect(page).not_to have_content 'みょうじはひらがなで入力してください'
      end
    end

    context 'なまえが空の時' do
      it 'フォーカスが外れると、エラーメッセージが出ること' do
        fill_in 'user[first_name_kana]', with: ''
        find('#user-last-name-kana').click
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

      it '値を入力し、フォーカスが外れると、エラーメッセージが消えること' do
        fill_in 'user[first_name_kana]', with: ''
        find('#user-first-name-kana').click
        fill_in 'user[first_name_kana]', with: 'ゆーざー'
        find('#user-first-name-kana').click
        expect(page).not_to have_content 'なまえを入力してください'
      end
    end

    context 'なまえが漢字の時' do
      it 'フォーカスが外れると、エラーメッセージが出ること' do
        fill_in 'user[first_name_kana]', with: '利用者'
        find('#user-last-name-kana').click
        expect(page).to have_content 'なまえはひらがなで入力してください'
      end

      it 'ページ遷移しないこと' do
        fill_in 'user[employee_id]', with: 'ID1234'
        fill_in 'user[password]', with: 'Test1234'
        fill_in 'user[password_confirmation]', with: 'Test1234'
        fill_in 'user[last_name]', with: 'テスト'
        fill_in 'user[first_name]', with: 'ユーザー'
        fill_in 'user[last_name_kana]', with: 'てすと'
        fill_in 'user[first_name_kana]', with: '利用者'
        click_on '新規登録'
        expect(current_path).to eq new_user_registration_path
      end

      it '値を入力し、フォーカスが外れると、エラーメッセージが消えること' do
        fill_in 'user[first_name_kana]', with: '利用者'
        find('#user-first-name-kana').click
        fill_in 'user[first_name_kana]', with: 'ゆーざー'
        find('#user-first-name-kana').click
        expect(page).not_to have_content 'なまえはひらがなで入力してください'
      end
    end

    context 'みょうじがカタカナの時' do
      it 'フォーカスが外れると、エラーメッセージが出ること' do
        fill_in 'user[first_name_kana]', with: 'ユーザー'
        find('#user-last-name-kana').click
        expect(page).to have_content 'なまえはひらがなで入力してください'
      end

      it 'ページ遷移しないこと' do
        fill_in 'user[employee_id]', with: 'ID1234'
        fill_in 'user[password]', with: 'Test1234'
        fill_in 'user[password_confirmation]', with: 'Test1234'
        fill_in 'user[last_name]', with: 'テスト'
        fill_in 'user[first_name]', with: 'ユーザー'
        fill_in 'user[last_name_kana]', with: 'てすと'
        fill_in 'user[first_name_kana]', with: 'ユーザー'
        click_on '新規登録'
        expect(current_path).to eq new_user_registration_path
      end

      it '値を入力し、フォーカスが外れると、エラーメッセージが消えること' do
        fill_in 'user[first_name_kana]', with: 'ユーザー'
        find('#user-first-name-kana').click
        fill_in 'user[first_name_kana]', with: 'ゆーざー'
        find('#user-first-name-kana').click
        expect(page).not_to have_content 'なまえはひらがなで入力してください'
      end
    end

    context 'なまえが英字の時' do
      it 'フォーカスが外れると、エラーメッセージが出ること' do
        fill_in 'user[first_name_kana]', with: 'user'
        find('#user-last-name-kana').click
        expect(page).to have_content 'なまえはひらがなで入力してください'
      end

      it 'ページ遷移しないこと' do
        fill_in 'user[employee_id]', with: 'ID1234'
        fill_in 'user[password]', with: 'Test1234'
        fill_in 'user[password_confirmation]', with: 'Test1234'
        fill_in 'user[last_name]', with: 'テスト'
        fill_in 'user[first_name]', with: 'ユーザー'
        fill_in 'user[last_name_kana]', with: 'てすと'
        fill_in 'user[first_name_kana]', with: 'user'
        click_on '新規登録'
        expect(current_path).to eq new_user_registration_path
      end

      it '値を入力し、フォーカスが外れると、エラーメッセージが消えること' do
        fill_in 'user[first_name_kana]', with: 'user'
        find('#user-first-name-kana').click
        fill_in 'user[first_name_kana]', with: 'ゆーざー'
        find('#user-first-name-kana').click
        expect(page).not_to have_content 'なまえはひらがなで入力してください'
      end
    end

    it '未入力項目があるとsubmitできないこと' do
      click_on '新規登録'
      expect(current_path).to eq new_user_registration_path
    end

    it '新規登録ボタンを押した時、エラー箇所まで自動スクロールされること' do
      page.driver.browser.manage.window.resize_to(1000, 300)
      fill_in 'user[employee_id]', with: ''
      fill_in 'user[password]', with: 'Test1234'
      fill_in 'user[password_confirmation]', with: 'Test1234'
      fill_in 'user[last_name]', with: 'テスト'
      fill_in 'user[first_name]', with: 'ユーザー'
      fill_in 'user[last_name_kana]', with: 'てすと'
      fill_in 'user[first_name_kana]', with: 'ゆーざー'
      click_on '新規登録'
      sleep 1
      error_center_position = page.execute_script('return Math.floor($(".error-frame").offset().top - ($(window).height() / 2))')
      scroll_y = page.execute_script('return window.pageYOffset')
      expect(scroll_y).to eq(error_center_position)
    end
  end

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

      it 'エラーメッセージが出ること' do
        expect(page).to have_content '社員IDとパスワードを確認してください'
      end
    end

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

      it 'エラーメッセージが出ること' do
        expect(page).to have_content '社員IDとパスワードを確認してください'
      end
    end

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

      it 'エラーメッセージが出ること' do
        expect(page).to have_content '社員IDとパスワードを確認してください'
      end
    end

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

      it 'エラーメッセージが出ること' do
        expect(page).to have_content '社員IDとパスワードを確認してください'
      end
    end
  end
end
