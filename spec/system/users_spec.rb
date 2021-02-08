require 'rails_helper'

shared_examples 'form test' do |error_message, input_selector, input_field, valid_value|
  context '入力欄からフォーカスが外れたとき' do
    before { find('.new-user-title').click }  # フォーカス外し

    it { expect(page).to have_content error_message }

    it { expect(page).to have_selector input_selector, class: 'error-frame' }
  end

  context '新規登録ボタンを押したとき' do
    before do
      find('.new-user-title').click  # フォーカス外し Ajaxの一意性チェックを待つため。
      click_on '新規登録'
    end

    it { expect(current_path).to eq new_user_registration_path }
  end

  context '有効な値を入力しなおして、フォーカスが外れたとき' do
    before do
      find('.new-user-title').click  # フォーカス外し
      fill_in input_field, with: valid_value
      find('.new-user-title').click  # フォーカス外し
    end

    it { expect(page).not_to have_content error_message }

    it { expect(page).not_to have_selector input_selector, class: 'error-frame' }
  end
end

RSpec.describe 'Users', type: :system do
  describe '新規登録', js: true do
    before { visit new_user_registration_path }

    context '全ての値が正しく入力されていた場合' do
      before do
        fill_in 'user[employee_id]', with: 'ID1234'
        fill_in 'user[password]', with: 'Test1234'
        fill_in 'user[password_confirmation]', with: 'Test1234'
        fill_in 'user[last_name]', with: 'テスト'
        fill_in 'user[first_name]', with: 'ユーザー'
        fill_in 'user[last_name_kana]', with: 'てすと'
        fill_in 'user[first_name_kana]', with: 'ゆーざー'
      end

      context 'Enterキーを押したとき' do
        before { find('body').send_keys(:enter) }

        it { expect(current_path).to eq new_user_registration_path }
      end
      context '新規登録ボタンを押したとき' do
        before { click_on '新規登録' }

        it { expect(current_path).to eq root_path }
      end
    end

    context '社員IDが入力されていなかった場合' do
      before do
        fill_in 'user[password]', with: 'Test1234'
        fill_in 'user[password_confirmation]', with: 'Test1234'
        fill_in 'user[last_name]', with: 'テスト'
        fill_in 'user[first_name]', with: 'ユーザー'
        fill_in 'user[last_name_kana]', with: 'てすと'
        fill_in 'user[first_name_kana]', with: 'ゆーざー'

        fill_in 'user[employee_id]', with: ''
      end

      it_behaves_like 'form test', '社員IDを入力してください', '#user-employee', 'user[employee_id]', 'ID1234'
    end

    context '社員IDがすでに使われていた場合' do
      before do
        user = create(:user, employee_id: 'ID1234')

        fill_in 'user[password]', with: 'Test1234'
        fill_in 'user[password_confirmation]', with: 'Test1234'
        fill_in 'user[last_name]', with: 'テスト'
        fill_in 'user[first_name]', with: 'ユーザー'
        fill_in 'user[last_name_kana]', with: 'てすと'
        fill_in 'user[first_name_kana]', with: 'ゆーざー'

        fill_in 'user[employee_id]', with: user.employee_id
      end

      it_behaves_like 'form test', 'その社員IDはすでに使用されています', '#user-employee', 'user[employee_id]', 'otherID5678'
    end

    context 'パスワードが入力されていなかった場合' do
      before do
        fill_in 'user[employee_id]', with: 'ID1234'
        fill_in 'user[password_confirmation]', with: 'Test1234'
        fill_in 'user[last_name]', with: 'テスト'
        fill_in 'user[first_name]', with: 'ユーザー'
        fill_in 'user[last_name_kana]', with: 'てすと'
        fill_in 'user[first_name_kana]', with: 'ゆーざー'

        fill_in 'user[password]', with: ''
      end

      it_behaves_like 'form test', 'パスワードを入力してください', '#user-password', 'user[password]', 'Test1234'
    end

    context 'パスワードが8文字より少ない場合' do
      before do
        fill_in 'user[employee_id]', with: 'ID1234'
        fill_in 'user[password_confirmation]', with: 'Test1234'
        fill_in 'user[last_name]', with: 'テスト'
        fill_in 'user[first_name]', with: 'ユーザー'
        fill_in 'user[last_name_kana]', with: 'てすと'
        fill_in 'user[first_name_kana]', with: 'ゆーざー'

        fill_in 'user[password]', with: 'Test12'
      end

      it_behaves_like 'form test', '8文字以上で入力してください', '#user-password', 'user[password]', 'Test1234'
    end

    context 'パスワードが16文字より多い場合' do
      before do
        fill_in 'user[employee_id]', with: 'ID1234'
        fill_in 'user[password_confirmation]', with: 'Test1234'
        fill_in 'user[last_name]', with: 'テスト'
        fill_in 'user[first_name]', with: 'ユーザー'
        fill_in 'user[last_name_kana]', with: 'てすと'
        fill_in 'user[first_name_kana]', with: 'ゆーざー'

        fill_in 'user[password]', with: 'Test1234567890abcd'
      end

      it_behaves_like 'form test', '16文字以下で入力してください', '#user-password', 'user[password]', 'Test1234'
    end

    context 'パスワードに英大小・数字以外が含まれていた場合' do
      before do
        fill_in 'user[employee_id]', with: 'ID1234'
        fill_in 'user[password_confirmation]', with: 'Test1234'
        fill_in 'user[last_name]', with: 'テスト'
        fill_in 'user[first_name]', with: 'ユーザー'
        fill_in 'user[last_name_kana]', with: 'てすと'
        fill_in 'user[first_name_kana]', with: 'ゆーざー'

        fill_in 'user[password]', with: '%test@1234&'
      end

      it_behaves_like 'form test', '半角英数字以外は使用できません', '#user-password', 'user[password]', 'Test1234'
    end

    context 'パスワードに英大文字が含まれていなかった場合' do
      before do
        fill_in 'user[employee_id]', with: 'ID1234'
        fill_in 'user[password_confirmation]', with: 'Test1234'
        fill_in 'user[last_name]', with: 'テスト'
        fill_in 'user[first_name]', with: 'ユーザー'
        fill_in 'user[last_name_kana]', with: 'てすと'
        fill_in 'user[first_name_kana]', with: 'ゆーざー'

        fill_in 'user[password]', with: 'test1234'
      end

      it_behaves_like 'form test', '"英大文字"を含めてください', '#user-password', 'user[password]', 'Test1234'
    end

    context 'パスワードに英小文字が含まれていなかった場合' do
      before do
        fill_in 'user[employee_id]', with: 'ID1234'
        fill_in 'user[password_confirmation]', with: 'Test1234'
        fill_in 'user[last_name]', with: 'テスト'
        fill_in 'user[first_name]', with: 'ユーザー'
        fill_in 'user[last_name_kana]', with: 'てすと'
        fill_in 'user[first_name_kana]', with: 'ゆーざー'

        fill_in 'user[password]', with: 'TEST1234'
      end

      it_behaves_like 'form test', '"英小文字"を含めてください', '#user-password', 'user[password]', 'Test1234'
    end

    context 'パスワードに数字が含まれていなかった場合' do
      before do
        fill_in 'user[employee_id]', with: 'ID1234'
        fill_in 'user[password_confirmation]', with: 'Test1234'
        fill_in 'user[last_name]', with: 'テスト'
        fill_in 'user[first_name]', with: 'ユーザー'
        fill_in 'user[last_name_kana]', with: 'てすと'
        fill_in 'user[first_name_kana]', with: 'ゆーざー'

        fill_in 'user[password]', with: 'TestTest'
      end

      it_behaves_like 'form test', '"数字"を含めてください', '#user-password', 'user[password]', 'Test1234'
    end

    context 'パスワード(確認)が入力されていなかった場合' do
      before do
        fill_in 'user[employee_id]', with: 'ID1234'
        fill_in 'user[password]', with: 'Test1234'
        fill_in 'user[last_name]', with: 'テスト'
        fill_in 'user[first_name]', with: 'ユーザー'
        fill_in 'user[last_name_kana]', with: 'てすと'
        fill_in 'user[first_name_kana]', with: 'ゆーざー'

        fill_in 'user[password_confirmation]', with: ''
      end

      it_behaves_like 'form test', 'パスワード(確認)を入力してください', '#user-confirmation-password', 'user[password_confirmation]', 'Test1234'
    end

    context 'パスワード(確認)がパスワードに入力した値と違った場合' do
      before do
        fill_in 'user[employee_id]', with: 'ID1234'
        fill_in 'user[last_name]', with: 'テスト'
        fill_in 'user[first_name]', with: 'ユーザー'
        fill_in 'user[last_name_kana]', with: 'てすと'
        fill_in 'user[first_name_kana]', with: 'ゆーざー'

        fill_in 'user[password]', with: 'Test1234'

        fill_in 'user[password_confirmation]', with: 'User5678'
      end

      it_behaves_like 'form test', 'パスワードを確認してください', '#user-confirmation-password', 'user[password_confirmation]', 'Test1234'
    end

    context '名字が入力されていなかった場合' do
      before do
        fill_in 'user[employee_id]', with: 'ID1234'
        fill_in 'user[password]', with: 'Test1234'
        fill_in 'user[password_confirmation]', with: 'Test1234'
        fill_in 'user[first_name]', with: 'ユーザー'
        fill_in 'user[last_name_kana]', with: 'てすと'
        fill_in 'user[first_name_kana]', with: 'ゆーざー'

        fill_in 'user[last_name]', with: ''
      end

      it_behaves_like 'form test', '名字を入力してください', '#user-last-name', 'user[last_name]', 'テスト'
    end

    context '名前が入力されていなかった場合' do
      before do
        fill_in 'user[employee_id]', with: 'ID1234'
        fill_in 'user[password]', with: 'Test1234'
        fill_in 'user[password_confirmation]', with: 'Test1234'
        fill_in 'user[last_name]', with: 'テスト'
        fill_in 'user[last_name_kana]', with: 'てすと'
        fill_in 'user[first_name_kana]', with: 'ゆーざー'

        fill_in 'user[first_name]', with: ''
      end

      it_behaves_like 'form test', '名前を入力してください', '#user-first-name', 'user[first_name]', 'ユーザー'
    end

    context 'みょうじが入力されていなかった場合' do
      before do
        fill_in 'user[employee_id]', with: 'ID1234'
        fill_in 'user[password]', with: 'Test1234'
        fill_in 'user[password_confirmation]', with: 'Test1234'
        fill_in 'user[last_name]', with: 'テスト'
        fill_in 'user[first_name]', with: 'ユーザー'
        fill_in 'user[first_name_kana]', with: 'ゆーざー'

        fill_in 'user[last_name_kana]', with: ''
      end

      it_behaves_like 'form test', 'みょうじを入力してください', '#user-last-name-kana', 'user[last_name_kana]', 'てすと'
    end

    context 'みょうじが漢字で入力されていた場合' do
      before do
        fill_in 'user[employee_id]', with: 'ID1234'
        fill_in 'user[password]', with: 'Test1234'
        fill_in 'user[password_confirmation]', with: 'Test1234'
        fill_in 'user[last_name]', with: 'テスト'
        fill_in 'user[first_name]', with: 'ユーザー'
        fill_in 'user[first_name_kana]', with: 'ゆーざー'

        fill_in 'user[last_name_kana]', with: '試験'
      end

      it_behaves_like 'form test', 'みょうじはひらがなで入力してください', '#user-last-name-kana', 'user[last_name_kana]', 'てすと'
    end

    context 'みょうじがカタカナで入力されていた場合' do
      before do
        fill_in 'user[employee_id]', with: 'ID1234'
        fill_in 'user[password]', with: 'Test1234'
        fill_in 'user[password_confirmation]', with: 'Test1234'
        fill_in 'user[last_name]', with: 'テスト'
        fill_in 'user[first_name]', with: 'ユーザー'
        fill_in 'user[first_name_kana]', with: 'ゆーざー'

        fill_in 'user[last_name_kana]', with: 'テスト'
      end

      it_behaves_like 'form test', 'みょうじはひらがなで入力してください', '#user-last-name-kana', 'user[last_name_kana]', 'てすと'
    end

    context 'みょうじが英字の時' do
      before do
        fill_in 'user[employee_id]', with: 'ID1234'
        fill_in 'user[password]', with: 'Test1234'
        fill_in 'user[password_confirmation]', with: 'Test1234'
        fill_in 'user[last_name]', with: 'テスト'
        fill_in 'user[first_name]', with: 'ユーザー'
        fill_in 'user[first_name_kana]', with: 'ゆーざー'

        fill_in 'user[last_name_kana]', with: 'test'
      end

      it_behaves_like 'form test', 'みょうじはひらがなで入力してください', '#user-last-name-kana', 'user[last_name_kana]', 'てすと'
    end

    context 'なまえが入力されていなかった場合' do
      before do
        fill_in 'user[employee_id]', with: 'ID1234'
        fill_in 'user[password]', with: 'Test1234'
        fill_in 'user[password_confirmation]', with: 'Test1234'
        fill_in 'user[last_name]', with: 'テスト'
        fill_in 'user[first_name]', with: 'ユーザー'
        fill_in 'user[last_name_kana]', with: 'てすと'

        fill_in 'user[first_name_kana]', with: ''
      end

      it_behaves_like 'form test', 'なまえを入力してください', '#user-first-name-kana', 'user[first_name_kana]', 'ゆーざー'
    end

    context 'なまえが漢字で入力されていた場合' do
      before do
        fill_in 'user[employee_id]', with: 'ID1234'
        fill_in 'user[password]', with: 'Test1234'
        fill_in 'user[password_confirmation]', with: 'Test1234'
        fill_in 'user[last_name]', with: 'テスト'
        fill_in 'user[first_name]', with: 'ユーザー'
        fill_in 'user[last_name_kana]', with: 'てすと'

        fill_in 'user[first_name_kana]', with: '利用者'
      end

      it_behaves_like 'form test', 'なまえはひらがなで入力してください', '#user-first-name-kana', 'user[first_name_kana]', 'ゆーざー'
    end

    context 'みょうじがカタカナで入力されていた場合' do
      before do
        fill_in 'user[employee_id]', with: 'ID1234'
        fill_in 'user[password]', with: 'Test1234'
        fill_in 'user[password_confirmation]', with: 'Test1234'
        fill_in 'user[last_name]', with: 'テスト'
        fill_in 'user[first_name]', with: 'ユーザー'
        fill_in 'user[last_name_kana]', with: 'てすと'

        fill_in 'user[first_name_kana]', with: 'ユーザー'
      end

      it_behaves_like 'form test', 'なまえはひらがなで入力してください', '#user-first-name-kana', 'user[first_name_kana]', 'ゆーざー'
    end

    context 'なまえが英字で入力されていた場合' do
      before do
        fill_in 'user[employee_id]', with: 'ID1234'
        fill_in 'user[password]', with: 'Test1234'
        fill_in 'user[password_confirmation]', with: 'Test1234'
        fill_in 'user[last_name]', with: 'テスト'
        fill_in 'user[first_name]', with: 'ユーザー'
        fill_in 'user[last_name_kana]', with: 'てすと'

        fill_in 'user[first_name_kana]', with: 'user'
      end

      it_behaves_like 'form test', 'なまえはひらがなで入力してください', '#user-first-name-kana', 'user[first_name_kana]', 'ゆーざー'
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

    context '全ての値が正しく入力されていた場合' do
      before do
        user = create(:user)
        fill_in 'user[employee_id]', with: user.employee_id
        fill_in 'user[password]', with: user.password
        click_on 'ログイン'
      end

      it { expect(current_path).to eq root_path }
    end

    context '社員IDが入力されていなかった場合' do
      before do
        user = create(:user)
        fill_in 'user[employee_id]', with: ''
        fill_in 'user[password]', with: user.password
        click_on 'ログイン'
      end

      it { expect(current_path).to eq new_user_session_path }

      it { expect(page).to have_content '社員IDとパスワードを確認してください' }
    end

    context '社員IDが間違っていた場合' do
      before do
        user = create(:user, employee_id: 'id1234')
        fill_in 'user[employee_id]', with: 'test5678'
        fill_in 'user[password]', with: user.password
        click_on 'ログイン'
      end

      it { expect(current_path).to eq new_user_session_path }

      it { expect(page).to have_content '社員IDとパスワードを確認してください' }
    end

    context 'パスワードが入力されていない時' do
      before do
        user = create(:user)
        fill_in 'user[employee_id]', with: user.employee_id
        fill_in 'user[password]', with: ''
        click_on 'ログイン'
      end

      it { expect(current_path).to eq new_user_session_path }

      it { expect(page).to have_content '社員IDとパスワードを確認してください' }
    end

    context 'パスワードが間違っている時' do
      before do
        user = create(:user, password: 'Test1234')
        fill_in 'user[employee_id]', with: user.employee_id
        fill_in 'user[password]', with: 'user5678'
        click_on 'ログイン'
      end

      it { expect(current_path).to eq new_user_session_path }

      it { expect(page).to have_content '社員IDとパスワードを確認してください' }
    end
  end
end
