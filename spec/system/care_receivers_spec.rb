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
        it 'submitされないこと' do
          fill_in 'care_receiver[last_name]', with: '山田'
          fill_in 'care_receiver[first_name]', with: '太郎'
          fill_in 'care_receiver[last_name_kana]', with: 'やまだ'
          fill_in 'care_receiver[first_name_kana]', with: 'たろう'
          select '2000', from: 'care_receiver[birthday(1i)]'
          select '1', from: 'care_receiver[birthday(2i)]'
          select '1', from: 'care_receiver[birthday(3i)]'
          find('#care_receiver-last_name').send_keys(:enter)
          expect(current_path).to eq new_care_receiver_path
        end
      end

      context '全ての値が正しく入力されている時' do
        it 'ホームページに遷移すること' do
          fill_in 'care_receiver[last_name]', with: '山田'
          fill_in 'care_receiver[first_name]', with: '太郎'
          fill_in 'care_receiver[last_name_kana]', with: 'やまだ'
          fill_in 'care_receiver[first_name_kana]', with: 'たろう'
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
          it 'ページ遷移しないこと' do
            fill_in 'care_receiver[last_name]', with: ''
            fill_in 'care_receiver[first_name]', with: '太郎'
            fill_in 'care_receiver[last_name_kana]', with: 'やまだ'
            fill_in 'care_receiver[first_name_kana]', with: 'たろう'
            select '2000', from: 'care_receiver[birthday(1i)]'
            select '1', from: 'care_receiver[birthday(2i)]'
            select '1', from: 'care_receiver[birthday(3i)]'
            click_on '新規登録'
            expect(current_path).to eq new_care_receiver_path
          end

          context 'フォーカスが外れた時' do
            before do
              fill_in 'care_receiver[last_name]', with: ''
              find('#first_name-label').click
            end

            # ラベルが赤くなること
            # 要修正
            # it { expect(find('#last_name-label')).to have_selector '.error-label' }

            it { expect(page).to have_selector '#last_name-error', text: '入力してください' }

            # フォームの枠が赤くなること
            # 要修正
            # it { expect(find('#care_receiver-last_name')).to have_css '.error-frame' }
          end

          context '値を入力し、フォーカスが外れた時' do
            before do
              fill_in 'care_receiver[last_name]', with: ''
              find('#care_receiver-first_name').click
              fill_in 'care_receiver[last_name]', with: '山田'
              find('#care_receiver-first_name').click
            end

            # 要修正
            # it { expect(find('#last_name-label')).not_to have_css '.error-label' }

            it { expect(page).not_to have_selector '#last_name-error', text: '入力してください' }

            # 要修正
            # it { expect(find('#care_receiver-last_name')).not_to have_css '.error-frame' }
          end
        end
      end

      describe 'input: 名前' do
        context '空の場合' do
          it 'ページ遷移しないこと' do
            fill_in 'care_receiver[last_name]', with: '山田'
            fill_in 'care_receiver[first_name]', with: ''
            fill_in 'care_receiver[last_name_kana]', with: 'やまだ'
            fill_in 'care_receiver[first_name_kana]', with: 'たろう'
            select '2000', from: 'care_receiver[birthday(1i)]'
            select '1', from: 'care_receiver[birthday(2i)]'
            select '1', from: 'care_receiver[birthday(3i)]'
            click_on '新規登録'
            expect(current_path).to eq new_care_receiver_path
          end

          context 'フォーカスが外れた時' do
            before do
              fill_in 'care_receiver[first_name]', with: ''
              find('#care_receiver-last_name_kana').click
            end

            # 要修正
            # it { expect(find('#first_name-label')).to have_css '.error-label' }

            it { expect(page).to have_selector '#first_name-error', text: '入力してください' }

            # 要修正
            # it { expect(find('#care_receiver-first_name')).to have_css '.error-frame' }
          end

          context '値を入力し、フォーカスが外れた時' do
            before do
              fill_in 'care_receiver[first_name]', with: ''
              find('#care_receiver-last_name_kana').click
              fill_in 'care_receiver[first_name]', with: '太郎'
              find('#care_receiver-last_name_kana').click
            end

            # 要修正
            # it { expect(find('#first_name-label')).not_to have_css '.error-label' }

            it { expect(page).not_to have_selector '#first_name-error', text: '入力してください' }

            # 要修正
            # it { expect(find('#care_receiver-first_name')).not_to have_css '.error-frame' }
          end
        end
      end

      describe 'input: みょうじ' do
        context 'みょうじが空の場合' do
          it 'ページ遷移しないこと' do
            fill_in 'care_receiver[last_name]', with: '山田'
            fill_in 'care_receiver[first_name]', with: '太郎'
            fill_in 'care_receiver[last_name_kana]', with: ''
            fill_in 'care_receiver[first_name_kana]', with: 'たろう'
            select '2000', from: 'care_receiver[birthday(1i)]'
            select '1', from: 'care_receiver[birthday(2i)]'
            select '1', from: 'care_receiver[birthday(3i)]'
            click_on '新規登録'
            expect(current_path).to eq new_care_receiver_path
          end

          context 'フォーカスが外れた時' do
            before do
              fill_in 'care_receiver[last_name_kana]', with: ''
              find('#care_receiver-first_name_kana').click
            end

            # 要修正
            # it { expect(find('#last_name_kana-label')).to have_css '.error-label' }

            it { expect(page).to have_selector '#last_name_kana-error', text: '入力してください' }

            # 要修正
            # it { expect(find('#care_receiver-last_name_kana').to have_css '.error-frame' }
          end

          context 'ひらがなで値を入力し、フォーカスが外れた時' do
            before do
              fill_in 'care_receiver[last_name_kana]', with: ''
              find('#care_receiver-first_name_kana').click
              fill_in 'care_receiver[last_name_kana]', with: 'やまだ'
              find('#care_receiver-first_name_kana').click
            end

            # 要修正
            # it { expect(find('#last_name_kana-label')).not_to have_css '.error-label' }

            it { expect(page).not_to have_selector '#last_name_kana-error', text: '入力してください' }

            # 要修正
            # it { expect(find('#care_receiver-last_name_kana').not_to have_css '.error-frame' }
          end
        end

        context '漢字の場合' do
          context 'フォーカスが外れた時' do
            before do
              fill_in 'care_receiver[last_name_kana]', with: '山田'
              find('#care_receiver-first_name_kana').click
            end

            # 要修正
            # it { expect(find('#last_name_kana-label')).to have_css '.error-label' }

            it { expect(page).to have_selector '#last_name-hiragana_error', text: 'ひらがなで入力してください' }

            # 要修正
            # it { expect(find('#care_receiver-last_name_kana').to have_css '.error-frame' }
          end

          context 'ひらがなで値を入力し、フォーカスが外れた時' do
            before do
              fill_in 'care_receiver[last_name_kana]', with: ''
              find('#care_receiver-first_name_kana').click
              fill_in 'care_receiver[last_name_kana]', with: 'やまだ'
              find('#care_receiver-first_name_kana').click
            end

            # 要修正
            # it { expect(find('#last_name_kana-label')).not_to have_css '.error-label' }

            it { expect(page).not_to have_selector '#last_name-hiragana_error', text: 'ひらがなで入力してください' }

            # 要修正
            # it { expect(find('#care_receiver-last_name_kana').not_to have_css '.error-frame' }
          end
        end

        context 'カタカナの場合' do
          context 'フォーカスが外れた時' do
            before do
              fill_in 'care_receiver[last_name_kana]', with: 'ヤマダ'
              find('#care_receiver-first_name_kana').click
            end

            # 要修正
            # it { expect(find('#last_name_kana-label')).to have_css '.error-label' }

            it { expect(page).to have_selector '#last_name-hiragana_error', text: 'ひらがなで入力してください' }

            # 要修正
            # it { expect(find('#care_receiver-last_name_kana').to have_css '.error-frame' }
          end

          context 'ひらがなで値を入力し、フォーカスが外れた時' do
            before do
              fill_in 'care_receiver[last_name_kana]', with: ''
              find('#care_receiver-first_name_kana').click
              fill_in 'care_receiver[last_name_kana]', with: 'やまだ'
              find('#care_receiver-first_name_kana').click
            end

            # 要修正
            # it { expect(find('#last_name_kana-label')).not_to have_css '.error-label' }

            it { expect(page).not_to have_selector '#last_name-hiragana_error', text: 'ひらがなで入力してください' }

            # 要修正
            # it { expect(find('#care_receiver-last_name_kana').not_to have_css '.error-frame' }
          end
        end

        context 'ローマ字の場合' do
          context 'フォーカスが外れた時' do
            before do
              fill_in 'care_receiver[last_name_kana]', with: 'yamada'
              find('#care_receiver-first_name_kana').click
            end

            # 要修正
            # it { expect(find('#last_name_kana-label')).to have_css '.error-label' }

            it { expect(page).to have_selector '#last_name-hiragana_error', text: 'ひらがなで入力してください' }

            # 要修正
            # it { expect(find('#care_receiver-last_name_kana').to have_css '.error-frame' }
          end

          context 'ひらがなで値を入力し、フォーカスが外れた時' do
            before do
              fill_in 'care_receiver[last_name_kana]', with: ''
              find('#care_receiver-first_name_kana').click
              fill_in 'care_receiver[last_name_kana]', with: 'やまだ'
              find('#care_receiver-first_name_kana').click
            end

            # 要修正
            # it { expect(find('#last_name_kana-label')).not_to have_css '.error-label' }

            it { expect(page).not_to have_selector '#last_name-hiragana_error', text: 'ひらがなで入力してください' }

            # 要修正
            # it { expect(find('#care_receiver-last_name_kana').not_to have_css '.error-frame' }
          end
        end

        context '全てひらがなでない場合' do
          context 'フォーカスが外れた時' do
            before do
              fill_in 'care_receiver[last_name_kana]', with: 'やま田'
              find('#care_receiver-first_name_kana').click
            end

            # 要修正
            # it { expect(find('#last_name_kana-label')).to have_css '.error-label' }

            it { expect(page).to have_selector '#last_name-hiragana_error', text: 'ひらがなで入力してください' }

            # 要修正
            # it { expect(find('#care_receiver-last_name_kana').to have_css '.error-frame' }
          end
        end

        context 'ひらがなで値を入力し、フォーカスが外れた時' do
          before do
            fill_in 'care_receiver[last_name_kana]', with: ''
            find('#care_receiver-first_name_kana').click
            fill_in 'care_receiver[last_name_kana]', with: 'やまだ'
            find('#care_receiver-first_name_kana').click
          end

          # 要修正
          # it { expect(find('#last_name_kana-label')).not_to have_css '.error-label' }

          it { expect(page).not_to have_selector '#last_name-hiragana_error', text: 'ひらがなで入力してください' }

          # 要修正
          # it { expect(find('#care_receiver-last_name_kana').not_to have_css '.error-frame' }
        end
      end

      describe 'input: なまえ' do
        context 'なまえが空の場合' do
          it 'ページ遷移しないこと' do
            fill_in 'care_receiver[last_name]', with: '山田'
            fill_in 'care_receiver[first_name]', with: '太郎'
            fill_in 'care_receiver[last_name_kana]', with: 'やまだ'
            fill_in 'care_receiver[first_name_kana]', with: ''
            select '2000', from: 'care_receiver[birthday(1i)]'
            select '1', from: 'care_receiver[birthday(2i)]'
            select '1', from: 'care_receiver[birthday(3i)]'
            click_on '新規登録'
            expect(current_path).to eq new_care_receiver_path
          end

          context 'フォーカスが外れた時' do
            before do
              fill_in 'care_receiver[first_name_kana]', with: ''
              find('#care_receiver-last_name_kana').click
            end

            # 要修正
            # it { expect(find('#first_name_kana-label')).to have_css '.error-label' }

            it { expect(page).to have_selector '#first_name_kana-error', text: '入力してください' }

            # 要修正
            # it { expect(find('#care_receiver-first_name_kana').to have_css '.error-frame' }
          end

          context 'ひらがなで値を入力し、フォーカスが外れた時' do
            before do
              fill_in 'care_receiver[first_name_kana]', with: ''
              find('#care_receiver-last_name_kana').click
              fill_in 'care_receiver[first_name_kana]', with: 'たろう'
              find('#care_receiver-last_name_kana').click
            end

            # 要修正
            # it { expect(find('#first_name_kana-label')).not_to have_css '.error-label' }

            it { expect(page).not_to have_selector '#first_name_kana-error', text: '入力してください' }

            # 要修正
            # it { expect(find('#care_receiver-first_name_kana').not_to have_css '.error-frame' }
          end
        end

        context '漢字の場合' do
          context 'フォーカスが外れた時' do
            before do
              fill_in 'care_receiver[first_name_kana]', with: '太郎'
              find('#care_receiver-last_name_kana').click
            end

            # 要修正
            # it { expect(find('#first_name_kana-label')).to have_css '.error-label' }

            it { expect(page).to have_selector '#first_name-hiragana_error', text: 'ひらがなで入力してください' }

            # 要修正
            # it { expect(find('#care_receiver-first_name_kana').to have_css '.error-frame' }
          end

          context 'ひらがなで値を入力し、フォーカスが外れた時' do
            before do
              fill_in 'care_receiver[first_name_kana]', with: ''
              find('#care_receiver-last_name_kana').click
              fill_in 'care_receiver[first_name_kana]', with: 'たろう'
              find('#care_receiver-last_name_kana').click
            end

            # 要修正
            # it { expect(find('#first_name_kana-label')).not_to have_css '.error-label' }

            it { expect(page).not_to have_selector '#first_name_kana-error', text: '入力してください' }

            # 要修正
            # it { expect(find('#care_receiver-first_name_kana').not_to have_css '.error-frame' }
          end
        end

        context 'カタカナの場合' do
          context 'フォーカスが外れた時' do
            before do
              fill_in 'care_receiver[first_name_kana]', with: 'タロウ'
              find('#care_receiver-last_name_kana').click
            end

            # 要修正
            # it { expect(find('#first_name_kana-label')).to have_css '.error-label' }

            it { expect(page).to have_selector '#first_name-hiragana_error', text: 'ひらがなで入力してください' }

            # 要修正
            # it { expect(find('#care_receiver-first_name_kana').to have_css '.error-frame' }
          end

          context 'ひらがなで値を入力し、フォーカスが外れた時' do
            before do
              fill_in 'care_receiver[first_name_kana]', with: ''
              find('#care_receiver-last_name_kana').click
              fill_in 'care_receiver[first_name_kana]', with: 'たろう'
              find('#care_receiver-last_name_kana').click
            end

            # 要修正
            # it { expect(find('#first_name_kana-label')).not_to have_css '.error-label' }

            it { expect(page).not_to have_selector '#first_name_kana-error', text: '入力してください' }

            # 要修正
            # it { expect(find('#care_receiver-first_name_kana').not_to have_css '.error-frame' }
          end
        end

        context 'ローマ字の場合' do
          context 'フォーカスが外れた時' do
            before do
              fill_in 'care_receiver[first_name_kana]', with: 'taro'
              find('#care_receiver-last_name_kana').click
            end

            # 要修正
            # it { expect(find('#first_name_kana-label')).to have_css '.error-label' }

            it { expect(page).to have_selector '#first_name-hiragana_error', text: 'ひらがなで入力してください' }

            # 要修正
            # it { expect(find('#care_receiver-first_name_kana').to have_css '.error-frame' }
          end

          context 'ひらがなで値を入力し、フォーカスが外れた時' do
            before do
              fill_in 'care_receiver[first_name_kana]', with: ''
              find('#care_receiver-last_name_kana').click
              fill_in 'care_receiver[first_name_kana]', with: 'たろう'
              find('#care_receiver-last_name_kana').click
            end

            # 要修正
            # it { expect(find('#first_name_kana-label')).not_to have_css '.error-label' }

            it { expect(page).not_to have_selector '#first_name_kana-error', text: '入力してください' }

            # 要修正
            # it { expect(find('#care_receiver-first_name_kana').not_to have_css '.error-frame' }
          end
        end

        context '全てひらがなでない場合' do
          context 'フォーカスが外れた時' do
            before do
              fill_in 'care_receiver[first_name_kana]', with: 'た郎'
              find('#care_receiver-last_name_kana').click
            end

            # 要修正
            # it { expect(find('#first_name_kana-label')).to have_css '.error-label' }

            it { expect(page).to have_selector '#first_name-hiragana_error', text: 'ひらがなで入力してください' }

            # 要修正
            # it { expect(find('#care_receiver-first_name_kana').to have_css '.error-frame' }
          end

          context 'ひらがなで値を入力し、フォーカスが外れた時' do
            before do
              fill_in 'care_receiver[first_name_kana]', with: ''
              find('#care_receiver-last_name_kana').click
              fill_in 'care_receiver[first_name_kana]', with: 'たろう'
              find('#care_receiver-last_name_kana').click
            end

            # 要修正
            # it { expect(find('#first_name_kana-label')).not_to have_css '.error-label' }

            it { expect(page).not_to have_selector '#first_name_kana-error', text: '入力してください' }

            # 要修正
            # it { expect(find('#care_receiver-first_name_kana').not_to have_css '.error-frame' }
          end
        end
      end

      describe 'input: 生年月日' do
        context '年が選択されていない場合' do
          it 'ページ遷移しないこと' do
            fill_in 'care_receiver[last_name]', with: '山田'
            fill_in 'care_receiver[first_name]', with: '太郎'
            fill_in 'care_receiver[last_name_kana]', with: 'やまだ'
            fill_in 'care_receiver[first_name_kana]', with: 'たろう'
            select '', from: 'care_receiver[birthday(1i)]'
            select '1', from: 'care_receiver[birthday(2i)]'
            select '1', from: 'care_receiver[birthday(3i)]'
            click_on '新規登録'
            expect(current_path).to eq new_care_receiver_path
          end

          context 'フォーカスが外れると、エラーメッセージが出ること' do
            before do
              find('#care_receiver_birthday_1i').click
              select '', from: 'care_receiver[birthday(1i)]'
              find('#care_receiver_birthday_2i').click
            end

            # 要修正
            # it { expect(find('#birthday-label')).to have_css '.error-label' }

            it { expect(page).to have_selector '#birthday-year-error', text: '選択してください' }

            # 要修正
            # it { expect(find('#care_receiver_birthday_1i')).to have_css '.error-frame' }
          end

          context '値を入力し、フォーカスが外れた時' do
            before do
              find('#care_receiver_birthday_1i').click
              select '', from: 'care_receiver[birthday(1i)]'
              find('#care_receiver_birthday_2i').click
              find('#care_receiver_birthday_1i').click
              select '2000', from: 'care_receiver[birthday(1i)]'
              find('#care_receiver_birthday_2i').click
            end

            # 要修正
            # it { expect(find('#birthday-label')).not_to have_css '.error-label' }

            it { expect(page).not_to have_selector '#birthday-year-error', text: '選択してください' }

            # 要修正
            # it { expect(find('#care_receiver_birthday_1i')).not_to have_css '.error-frame' }
          end
        end

        context '月が選択されていない場合' do
          it 'ページ遷移しないこと' do
            fill_in 'care_receiver[last_name]', with: '山田'
            fill_in 'care_receiver[first_name]', with: '太郎'
            fill_in 'care_receiver[last_name_kana]', with: 'やまだ'
            fill_in 'care_receiver[first_name_kana]', with: 'たろう'
            select '2000', from: 'care_receiver[birthday(1i)]'
            select '', from: 'care_receiver[birthday(2i)]'
            select '1', from: 'care_receiver[birthday(3i)]'
            click_on '新規登録'
            expect(current_path).to eq new_care_receiver_path
          end

          context 'フォーカスが外れた時' do
            before do
              find('#care_receiver_birthday_2i').click
              select '', from: 'care_receiver[birthday(2i)]'
              find('#care_receiver_birthday_3i').click
            end

            # 要修正
            # it { expect(find('#birthday-lagel')).to have_css '.error-label' }

            it { expect(page).to have_selector '#birthday-month-error', text: '選択してください' }

            # 要修正
            # it { expect(find('#care_receiver_birthday_2i')).to have_css '.error-frame' }
          end

          context '値を入力し、フォーカスが外れた時' do
            before do
              find('#care_receiver_birthday_2i').click
              select '', from: 'care_receiver[birthday(2i)]'
              find('#care_receiver_birthday_3i').click
              find('#care_receiver_birthday_2i').click
              select '1', from: 'care_receiver[birthday(2i)]'
              find('#care_receiver_birthday_3i').click
            end

            # 要修正
            # it { expect(find('#birthday-lagel')).not_to have_css '.error-label' }

            it { expect(page).not_to have_selector '#birthday-month-error', text: '選択してください' }

            # 要修正
            # it { expect(find('#care_receiver_birthday_2i')).not_to have_css '.error-frame' }
          end
        end

        context '生年月日 日が選択されていない場合' do
          it 'ページ遷移しないこと' do
            fill_in 'care_receiver[last_name]', with: '山田'
            fill_in 'care_receiver[first_name]', with: '太郎'
            fill_in 'care_receiver[last_name_kana]', with: 'やまだ'
            fill_in 'care_receiver[first_name_kana]', with: 'たろう'
            select '2000', from: 'care_receiver[birthday(1i)]'
            select '1', from: 'care_receiver[birthday(2i)]'
            select '', from: 'care_receiver[birthday(3i)]'
            click_on '新規登録'
            expect(current_path).to eq new_care_receiver_path
          end

          context 'フォーカスが外れるた時' do
            before do
              find('#care_receiver_birthday_3i').click
              select '', from: 'care_receiver[birthday(3i)]'
              find('#care_receiver_birthday_2i').click
            end

            # 要修正
            # it { expect(find('#birthday-lagel')).to have_css '.error-label' }

            it { expect(page).to have_selector '#birthday-date-error', text: '選択してください' }

            # 要修正
            # it { expect(find('#care_receiver_birthday_3i')).to have_css '.error-frame' }
          end

          context '値を入力し、フォーカスが外れた時' do
            before do
              find('#care_receiver_birthday_3i').click
              select '', from: 'care_receiver[birthday(3i)]'
              find('#care_receiver_birthday_2i').click
              find('#care_receiver_birthday_3i').click
              select '1', from: 'care_receiver[birthday(3i)]'
              find('#care_receiver_birthday_2i').click
            end

            # 要修正
            # it { expect(find('#birthday-lagel')).not_to have_css '.error-label' }

            it { expect(page).not_to have_selector '#birthday-date-error', text: '選択してください' }

            # 要修正
            # it { expect(find('#care_receiver_birthday_3i')).not_to have_css '.error-frame' }
          end
        end
      end
    end
  end
end
