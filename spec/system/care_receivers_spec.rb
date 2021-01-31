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
          expect(page).to have_content '登録しました'
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

  describe '詳細' do
    let!(:care_receiver) { create(:care_receiver) }

    subject { page }

    describe 'サイドメニュー' do
      before do
        visit root_path
        click_on "#{care_receiver.last_name} #{care_receiver.first_name}"
      end

      context '戻るボタンを押した時' do
        it 'ホーム画面に戻る' do
          click_on '戻る'
          expect(current_path).to eq root_path
        end
      end
    end

    describe '個人情報' do
      let(:name) { "#{care_receiver.last_name} #{care_receiver.first_name} 様" }
      let(:birthday) { care_receiver.birthday.strftime('%Y年 %-m月 %-d日') }
      let(:age) { (Date.today.strftime('%Y%m%d').to_i - care_receiver.birthday.strftime('%Y%m%d').to_i) / 10_000 }

      before do
        visit root_path
        click_on "#{care_receiver.last_name} #{care_receiver.first_name}"
      end

      it { is_expected.to have_content name }

      it { is_expected.to have_content birthday }

      it { is_expected.to have_content age }
    end

    describe '服薬 一覧' do
      context '服薬がある時' do
        let!(:other_care_receiver) { create(:care_receiver) }

        let!(:dosing_time_am) { create(:dosing_time, timeframe_id: 1, care_receiver_id: care_receiver.id) }
        let!(:dosing_time_pm) { create(:dosing_time, timeframe_id: 2, care_receiver_id: care_receiver.id) }
        let!(:dosing_time_other) { create(:dosing_time, timeframe_id: 3, care_receiver_id: other_care_receiver.id) }

        let!(:medicine_dosing_times_am) { create_list(:medicine_dosing_time, 5, dosing_time_id: dosing_time_am.id) }
        let!(:medicine_dosing_times_pm) { create_list(:medicine_dosing_time, 5, dosing_time_id: dosing_time_pm.id) }

        before do
          visit root_path
          click_on "#{care_receiver.last_name} #{care_receiver.first_name}"
        end

        it { is_expected.to have_content dosing_time_am.timeframe.name }

        it { is_expected.to have_css '.show-care_receiver__dosing_time--list--item', count: 2 }

        it { is_expected.to have_content dosing_time_am.medicines[0].name }

        it { is_expected.to have_css '.show-care_receiver__dosing_time--medicines_list--item', count: 10 }

        it { is_expected.not_to have_content dosing_time_other.timeframe.name }

        it { is_expected.not_to have_content '服薬はありません' }
      end

      context '服薬がない時' do
        before do
          visit root_path
          click_on "#{care_receiver.last_name} #{care_receiver.first_name}"
        end

        it { is_expected.to have_content '服薬はありません' }

        it { is_expected.to have_css '.show-care_receiver__dosing_time--list--item', count: 1 }
      end
    end
  end
end
