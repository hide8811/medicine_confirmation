require 'rails_helper'

RSpec.describe 'CareReceivers', type: :system do
  before do
    user = create(:user)
    login_as(user, scope: :user)
  end

  describe '新規登録' do
    describe 'サイドメニュー' do
      before do
        visit root_path
        click_on 'care_receiver 新規作成'
      end

      context '戻るボタンを押した時' do
        it 'ホーム画面に戻ること' do
          click_on '戻る'
          expect(current_path).to eq root_path
        end
      end

      context 'ホームボタンを押した時' do
        it 'ホーム画面に戻ること' do
          click_on 'ホーム'
          expect(current_path).to eq root_path
        end
      end
    end

    describe '入力フォーム', js: true do
      before do
        visit new_care_receiver_path
      end

      context 'フォーム内でEnterキーを押した時' do
        # it 'submitされないこと' do
        # end
      end

      context '全ての値が正しく入力されている時' do
        it 'ホームページに遷移すること' do
          fill_in 'care_receiver[last_name]', with: 'テスト'
          fill_in 'care_receiver[first_name]', with: 'ユーザー'
          fill_in 'care_receiver[last_name_kana]', with: 'てすと'
          fill_in 'care_receiver[first_name_kana]', with: 'ゆーざー'
          select '2000', from: 'care_receiver[birthday(1i)]'
          select '1', from: 'care_receiver[birthday(2i)]'
          select '1', from: 'care_receiver[birthday(3i)]'
          click_on '新規登録'
          sleep 2 # -------------------------------------------変更予定
          expect(current_path).to eq root_path
        end
      end

      describe 'input: 名字' do
        context '空の場合' do
          # it 'フォーカスが外れると、エラーメッセージが出ること' do
          # end

          it 'ページ遷移しないこと' do
            fill_in 'care_receiver[last_name]', with: ''
            fill_in 'care_receiver[first_name]', with: 'ユーザー'
            fill_in 'care_receiver[last_name_kana]', with: 'てすと'
            fill_in 'care_receiver[first_name_kana]', with: 'ゆーざー'
            select '2000', from: 'care_receiver[birthday(1i)]'
            select '1', from: 'care_receiver[birthday(2i)]'
            select '1', from: 'care_receiver[birthday(3i)]'
            click_on '新規登録'
            expect(current_path).to eq new_care_receiver_path
          end

          # it '値を入力し、フォーカスが外れると、エラーメッセージが消えること' do
          # end
        end
      end

      describe 'input: 名前' do
        context '名前が空の場合' do
          # it 'フォーカスが外れると、エラーメッセージが出ること' do
          # end

          it 'ページ遷移しないこと' do
            fill_in 'care_receiver[last_name]', with: 'テスト'
            fill_in 'care_receiver[first_name]', with: ''
            fill_in 'care_receiver[last_name_kana]', with: 'てすと'
            fill_in 'care_receiver[first_name_kana]', with: 'ゆーざー'
            select '2000', from: 'care_receiver[birthday(1i)]'
            select '1', from: 'care_receiver[birthday(2i)]'
            select '1', from: 'care_receiver[birthday(3i)]'
            click_on '新規登録'
            expect(current_path).to eq new_care_receiver_path
          end

          # it '値を入力し、フォーカスが外れると、エラーメッセージが消えること' do
          # end
        end
      end

      describe 'input: みょうじ' do
        context 'みょうじが空の場合' do
          # it 'フォーカスが外れると、エラーメッセージが出ること' do
          # end

          it 'ページ遷移しないこと' do
            fill_in 'care_receiver[last_name]', with: 'テスト'
            fill_in 'care_receiver[first_name]', with: 'ユーザー'
            fill_in 'care_receiver[last_name_kana]', with: ''
            fill_in 'care_receiver[first_name_kana]', with: 'ゆーざー'
            select '2000', from: 'care_receiver[birthday(1i)]'
            select '1', from: 'care_receiver[birthday(2i)]'
            select '1', from: 'care_receiver[birthday(3i)]'
            click_on '新規登録'
            expect(current_path).to eq new_care_receiver_path
          end

          # it '値を入力し、フォーカスが外れると、エラーメッセージが消えること' do
          # end
        end
      end

      describe 'input: なまえ' do
        context 'なまえが空の場合' do
          # it 'フォーカスが外れると、エラーメッセージが出ること' do
          # end

          it 'ページ遷移しないこと' do
            fill_in 'care_receiver[last_name]', with: 'テスト'
            fill_in 'care_receiver[first_name]', with: 'ユーザー'
            fill_in 'care_receiver[last_name_kana]', with: 'てすと'
            fill_in 'care_receiver[first_name_kana]', with: ''
            select '2000', from: 'care_receiver[birthday(1i)]'
            select '1', from: 'care_receiver[birthday(2i)]'
            select '1', from: 'care_receiver[birthday(3i)]'
            click_on '新規登録'
            expect(current_path).to eq new_care_receiver_path
          end

          # it '値を入力し、フォーカスが外れると、エラーメッセージが消えること' do
          # end
        end
      end

      describe 'input: 誕生日' do
        context '誕生年が選択されていない場合' do
          # it 'フォーカスが外れると、エラーメッセージが出ること' do
          # end

          it 'ページ遷移しないこと' do
            fill_in 'care_receiver[last_name]', with: 'テスト'
            fill_in 'care_receiver[first_name]', with: 'ユーザー'
            fill_in 'care_receiver[last_name_kana]', with: 'てすと'
            fill_in 'care_receiver[first_name_kana]', with: 'ゆーざー'
            select '', from: 'care_receiver[birthday(1i)]'
            select '1', from: 'care_receiver[birthday(2i)]'
            select '1', from: 'care_receiver[birthday(3i)]'
            click_on '新規登録'
            expect(current_path).to eq new_care_receiver_path
          end

          # it '値を入力し、フォーカスが外れると、エラーメッセージが消えること' do
          # end
        end

        context '誕生月が選択されていない場合' do
          # it 'フォーカスが外れると、エラーメッセージが出ること' do
          # end

          it 'ページ遷移しないこと' do
            fill_in 'care_receiver[last_name]', with: 'テスト'
            fill_in 'care_receiver[first_name]', with: 'ユーザー'
            fill_in 'care_receiver[last_name_kana]', with: 'てすと'
            fill_in 'care_receiver[first_name_kana]', with: 'ゆーざー'
            select '2000', from: 'care_receiver[birthday(1i)]'
            select '', from: 'care_receiver[birthday(2i)]'
            select '1', from: 'care_receiver[birthday(3i)]'
            click_on '新規登録'
            expect(current_path).to eq new_care_receiver_path
          end

          # it '値を入力し、フォーカスが外れると、エラーメッセージが消えること' do
          # end
        end

        context '誕生日が選択されていない場合' do
          # it 'フォーカスが外れると、エラーメッセージが出ること' do
          # end

          it 'ページ遷移しないこと' do
            fill_in 'care_receiver[last_name]', with: 'テスト'
            fill_in 'care_receiver[first_name]', with: 'ユーザー'
            fill_in 'care_receiver[last_name_kana]', with: 'てすと'
            fill_in 'care_receiver[first_name_kana]', with: 'ゆーざー'
            select '2000', from: 'care_receiver[birthday(1i)]'
            select '1', from: 'care_receiver[birthday(2i)]'
            select '', from: 'care_receiver[birthday(3i)]'
            click_on '新規登録'
            expect(current_path).to eq new_care_receiver_path
          end

          # it '値を入力し、フォーカスが外れると、エラーメッセージが消えること' do
          # end
        end
      end
    end
  end
end
