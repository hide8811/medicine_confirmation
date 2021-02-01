require 'rails_helper'

RSpec.describe 'CareReceivers', type: :system do
  shared_context 'Page transition to root_path' do
    before { visit root_path }
  end

  shared_context 'Page transition to new_care_receiver' do
    before do
      visit root_path
      click_on '新規登録'
    end
  end

  shared_context 'Page transition to show_care_receiver' do
    before do
      visit root_path
      click_on '詳細', id: "care_receiver_#{care_receiver.id}-show"
    end
  end

  before do
    user = create(:user)
    login_as(user, scope: :user)
  end

  describe '一覧表示 index' do
    describe 'サイドメニュー' do
      include_context 'Page transition to root_path'

      subject { current_path }

      context '新規登録ボタンを押した時' do
        before { click_on '新規登録' }
        it { is_expected.to eq new_care_receiver_path }
      end

      context '薬ボタンを押した時' do
        before { click_on '薬' }
        it { is_expected.to eq medicines_path }
      end

      context 'ログアウトボタンを押した時' do
        before { click_on 'ログアウト' }
        it { is_expected.to eq new_user_session_path }
      end
    end

    describe '利用者一覧' do
      subject { page }

      context '利用者が存在する場合' do
        let!(:care_receiver) { create(:care_receiver) }

        include_context 'Page transition to root_path'

        it { is_expected.to have_content "#{care_receiver.last_name} #{care_receiver.first_name}" }

        it { is_expected.to have_css '.care_receivers-list-item__show-link--btn' }
      end

      context '利用者が複数存在する場合' do
        before { create_list(:care_receiver, 10) }

        include_context 'Page transition to root_path'

        it { is_expected.to have_css '.care_receivers-list-item', count: 10 }
      end

      context '利用者が存在しない場合' do
        include_context 'Page transition to root_path'
        it { is_expected.to have_content '利用者は存在しません' }
      end
    end
  end

  describe '新規登録 new' do
    describe 'サイドメニュー' do
      include_context 'Page transition to new_care_receiver'

      context '戻るボタンを押した時' do
        before { click_on '戻る' }

        it { expect(current_path).to eq root_path }
      end

      context 'ホームボタンを押した時' do
        before { click_on 'ホーム' }

        it { expect(current_path).to eq root_path }
      end
    end

    describe '入力フォーム', js: true do
      include_context 'Page transition to new_care_receiver'

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

  describe '詳細 show' do
    let!(:care_receiver) { create(:care_receiver) }
    let(:dosing_time) { create(:dosing_time, care_receiver_id: care_receiver.id) }
    let(:medicine) { create(:medicine) }

    subject { page }

    describe 'サイドメニュー' do
      include_context 'Page transition to show_care_receiver'

      context '戻るボタンを押した場合' do
        before { click_on '戻る' }
        it { expect(current_path).to eq root_path }
      end
    end

    describe 'ご利用者様 情報表示' do
      let(:name) { "#{care_receiver.last_name} #{care_receiver.first_name} 様" }
      let(:birthday) { care_receiver.birthday.strftime('%Y年 %-m月 %-d日') }
      let(:age) { (Date.today.strftime('%Y%m%d').to_i - care_receiver.birthday.strftime('%Y%m%d').to_i) / 10_000 }

      include_context 'Page transition to show_care_receiver'

      it { is_expected.to have_content name }

      it { is_expected.to have_content birthday }

      it { is_expected.to have_content age }
    end

    describe '服薬 一覧' do
      context '服薬がある場合' do
        before { create(:medicine_dosing_time, medicine_id: medicine.id, dosing_time_id: dosing_time.id) }

        include_context 'Page transition to show_care_receiver'

        it { is_expected.to have_selector ".show_care_receiver-dosing_time_#{dosing_time.id}-name", text: dosing_time.timeframe.name }

        it { is_expected.to have_selector ".show_care_receiver-dosing_time_#{dosing_time.id}-medicine_#{medicine.id}-name", text: medicine.name }

        it { is_expected.not_to have_content '服薬はありません' }
      end

      context '複数の服薬がある場合' do
        let(:dosing_time_am) { create(:dosing_time, timeframe_id: 1, care_receiver_id: care_receiver.id) }
        let(:dosing_time_pm) { create(:dosing_time, timeframe_id: 2, care_receiver_id: care_receiver.id) }

        before do
          create_list(:medicine_dosing_time, 5, dosing_time_id: dosing_time_am.id)
          create_list(:medicine_dosing_time, 5, dosing_time_id: dosing_time_pm.id)
        end

        include_context 'Page transition to show_care_receiver'

        it { is_expected.to have_css '.dosing_time-show_care_receiver__list--item', count: 2 }

        it { is_expected.to have_css '.medicine-dosing_time-show_care_receiver', count: 10 }
      end

      context '服薬する薬に画像データがある場合' do
        before { create(:medicine_dosing_time, medicine_id: medicine.id, dosing_time_id: dosing_time.id) }

        include_context 'Page transition to show_care_receiver'

        it { is_expected.to have_css '.medicine-dosing_time-show_care_receiver__image' }

        it { is_expected.not_to have_css '.medicine-dosing_time-show_care_receiver__no-image' }
      end

      context '服薬する薬に画像データがない場合' do
        let(:no_image_medicine) { create(:medicine, image: '') }

        before { create(:medicine_dosing_time, medicine_id: no_image_medicine.id, dosing_time_id: dosing_time.id) }

        include_context 'Page transition to show_care_receiver'

        it { is_expected.to have_css '.medicine-dosing_time-show_care_receiver__no-image' }

        it { is_expected.not_to have_css '.medicine-dosing_time-show_care_receiver__image' }
      end

      context '服薬する薬にURLデータがある場合' do
        before { create(:medicine_dosing_time, medicine_id: medicine.id, dosing_time_id: dosing_time.id) }

        include_context 'Page transition to show_care_receiver'

        it { is_expected.to have_css '.medicine-dosing_time-show_care_receiver__url' }

        it { is_expected.not_to have_css '.medicine-dosing_time-show_care_receiver__no-url' }
      end

      context '服薬する薬にURLデータがない場合' do
        let(:no_url_medicine) { create(:medicine, url: '') }

        before { create(:medicine_dosing_time, medicine_id: no_url_medicine.id, dosing_time_id: dosing_time.id) }

        include_context 'Page transition to show_care_receiver'

        it { is_expected.to have_css '.medicine-dosing_time-show_care_receiver__no-url' }

        it { is_expected.not_to have_css '.medicine-dosing_time-show_care_receiver__url' }
      end

      context '服薬がない時' do
        include_context 'Page transition to show_care_receiver'

        it { is_expected.to have_content '服薬はありません' }

        it { is_expected.not_to have_css '.dosing_time-show_care_receiver__list' }
      end

      context '他の利用者にデータがある時' do
        let(:other_care_receiver) { create(:care_receiver) }
        let(:other_dosing_time) { create(:dosing_time, care_receiver_id: other_care_receiver.id) }

        before { create(:medicine_dosing_time, dosing_time_id: other_dosing_time.id) }

        include_context 'Page transition to show_care_receiver'

        it { is_expected.not_to have_content other_dosing_time.timeframe.name }
      end
    end
  end
end
