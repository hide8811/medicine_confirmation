require 'rails_helper'

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

shared_examples 'Form input focus test' do |column_name, violate_value, error_message|
  context 'フォーカスが外れたとき' do
    before do
      fill_in "care_receiver[#{column_name}]", with: violate_value
      find('.new-care_receiver-title').click # フォーカスはずし
    end

    it { is_expected.to have_selector "#label-#{column_name}-care_receiver-form", class: 'error-label' }
    it { is_expected.to have_selector "#input-#{column_name}-care_receiver-form", class: 'error-frame' }
    it { is_expected.to have_selector "#error-#{column_name}-care_receiver-form", text: error_message }

    context 'フォーカスが外れエラーが出た後、正しい値を入力したとき' do
      before do
        fill_in "care_receiver[#{column_name}]", with: valid_value # letで定義
        find('.new-care_receiver-title').click # フォーカスはずし
      end

      it { is_expected.not_to have_selector "#label-#{column_name}-care_receiver-form", class: 'error-label' }
      it { is_expected.not_to have_selector "#input-#{column_name}-care_receiver-form", class: 'error-frame' }
      it { is_expected.not_to have_selector "#error-#{column_name}-care_receiver-form", text: error_message }
    end
  end
end

shared_examples 'Form input button test' do |column_name, error_message|
  it { is_expected.to have_selector "#label-#{column_name}-care_receiver-form", class: 'error-label' }
  it { is_expected.to have_selector "#input-#{column_name}-care_receiver-form", class: 'error-frame' }
  it { is_expected.to have_selector "#error-#{column_name}-care_receiver-form", text: error_message }

  context '新規登録でエラーが出た後、正しい値を入力したとき' do
    before do
      fill_in "care_receiver[#{column_name}]", with: valid_value # letで定義
      click_on '新規登録'
    end

    it { is_expected.to have_content '登録しました' }
    it { is_expected.to have_content "#{care_receiver.last_name} #{care_receiver.first_name}" }
  end
end

shared_examples 'Form select focus test' do |date_position, valid_value|
  context 'フォーカスが外れたとき' do
    before do
      find("#care_receiver_birthday_#{date_position}").click
      select '', from: "care_receiver[birthday(#{date_position})]"
      find('.new-care_receiver-title').click # フォーカスはずし
    end

    it { is_expected.to have_selector '#label-birthday-care_receiver-form', class: 'error-label' }
    it { is_expected.to have_selector "#care_receiver_birthday_#{date_position}", class: 'error-frame' }
    it { is_expected.to have_selector '#error-birthday-care_receiver-form', text: '選択してください' }

    context 'フォーカスが外れエラーが出た後、正しい値を入力したとき' do
      before do
        find("#care_receiver_birthday_#{date_position}").click
        select valid_value, from: "care_receiver[birthday(#{date_position})]"
        find('.new-care_receiver-title').click # フォーカスはずし
      end

      it { is_expected.not_to have_selector '#label-birthday-care_receiver-form', class: 'error-label' }
      it { is_expected.not_to have_selector "#care_receiver_birthday_#{date_position}", class: 'error-frame' }
      it { is_expected.not_to have_selector '#error-birthday-care_receiver-form', text: '選択してください' }
    end
  end
end

shared_examples 'Form select focus test, if there are other errors' do |date_position, valid_value|
  context 'フォーカスが外れエラーが出た後、正しい値を入力したとき' do
    before do
      find("#care_receiver_birthday_#{date_position}").click
      select '', from: "care_receiver[birthday(#{date_position})]"
      find('.new-care_receiver-title').click # フォーカスはずし
      find("#care_receiver_birthday_#{date_position}").click
      select valid_value, from: "care_receiver[birthday(#{date_position})]"
      find('.new-care_receiver-title').click # フォーカスはずし
    end

    it { is_expected.to have_selector '#label-birthday-care_receiver-form', class: 'error-label' }
    it { is_expected.not_to have_selector "#care_receiver_birthday_#{date_position}", class: 'error-frame' }
    it { is_expected.to have_selector '#error-birthday-care_receiver-form', text: '選択してください' }
  end
end

shared_examples 'Form select button test' do |date_position, valid_value|
  it { is_expected.to have_selector '#label-birthday-care_receiver-form', class: 'error-label' }
  it { is_expected.to have_selector "#care_receiver_birthday_#{date_position}", class: 'error-frame' }
  it { is_expected.to have_selector '#error-birthday-care_receiver-form', text: '選択してください' }

  context '新規登録でエラーが出た後、正しい値を入力したとき' do
    before do
      select valid_value, from: "care_receiver[birthday(#{date_position})]"
      click_on '新規登録'
    end

    it { is_expected.to have_content '登録しました' }
    it { is_expected.to have_content "#{care_receiver.last_name} #{care_receiver.first_name}" }
  end
end

RSpec.describe 'CareReceivers', type: :system do
  before do
    user = create(:user)
    login_as(user, scope: :user)
  end

  describe '一覧表示 index' do
    describe 'サイドメニュー' do
      before { visit root_path }

      subject { current_path }

      context '新規登録ボタンを押した場合' do
        before { click_on '新規登録' }
        it { is_expected.to eq new_care_receiver_path }
      end

      context '薬ボタンを押した場合' do
        before { click_on '薬' }
        it { is_expected.to eq medicines_path }
      end

      context 'ログアウトボタンを押した場合' do
        before { click_on 'ログアウト' }
        it { is_expected.to eq new_user_session_path }
      end
    end

    describe '利用者一覧' do
      subject { page }

      context '利用者が存在した場合' do
        let!(:care_receiver) { create(:care_receiver) }

        before { visit root_path }

        it { is_expected.to have_content "#{care_receiver.last_name} #{care_receiver.first_name}" }

        it { is_expected.to have_css '.care_receivers-list-item__show-link--btn' }
      end

      context '利用者が複数存在する場合' do
        before do
          create_list(:care_receiver, 10)
          visit root_path
        end

        it { is_expected.to have_css '.care_receivers-list-item', count: 10 }
      end

      context '利用者が存在しない場合' do
        before { visit root_path }
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
      let(:care_receiver) { build(:care_receiver) }

      subject { page }

      include_context 'Page transition to new_care_receiver'

      context '全ての値が正しく入力されていた場合' do
        before do
          fill_in 'care_receiver[last_name]', with: care_receiver.last_name
          fill_in 'care_receiver[first_name]', with: care_receiver.first_name
          fill_in 'care_receiver[last_name_kana]', with: care_receiver.last_name_kana
          fill_in 'care_receiver[first_name_kana]', with: care_receiver.first_name_kana
          select care_receiver.birthday.strftime('%Y'), from: 'care_receiver[birthday(1i)]'
          select care_receiver.birthday.strftime('%-m'), from: 'care_receiver[birthday(2i)]'
          select care_receiver.birthday.strftime('%-d'), from: 'care_receiver[birthday(3i)]'
        end

        context 'フォーム内でEnterキーを押したとき' do
          before { page.all('form#care_receiver-form input')[rand(5)].send_keys(:enter) }
          it { expect(current_path).to eq new_care_receiver_path }
        end

        context '新規登録ボタンを押したとき' do
          before { click_on '新規登録' }

          it { is_expected.to have_content '登録しました' }
          it { is_expected.to have_content "#{care_receiver.last_name} #{care_receiver.first_name}" }
        end
      end

      context '何も入力せず、新規登録ボタンを押した場合' do
        before { click_on '新規登録' }

        it { is_expected.to have_css '.error-label', count: 5 }
        it { is_expected.to have_css '.error-frame', count: 7 }
        it { is_expected.to have_content '入力してください', count: 4 }
        it { is_expected.to have_content '選択してください', count: 1 }
      end
    end

    # 名字 ======================================================================
    describe 'input: last_name', js: true do
      let(:care_receiver) { build(:care_receiver) }
      let(:valid_value) { care_receiver.last_name } # shared_examplesで使用

      subject { page }

      include_context 'Page transition to new_care_receiver'

      context '名字を入力しなかった場合' do
        it_behaves_like 'Form input focus test', 'last_name', '', '入力してください'

        context '新規登録ボタンを押したとき' do
          before do
            # 'care_receiver[last_name]' 入力しない
            fill_in 'care_receiver[first_name]', with: care_receiver.first_name
            fill_in 'care_receiver[last_name_kana]', with: care_receiver.last_name_kana
            fill_in 'care_receiver[first_name_kana]', with: care_receiver.first_name_kana
            select care_receiver.birthday.strftime('%Y'), from: 'care_receiver[birthday(1i)]'
            select care_receiver.birthday.strftime('%-m'), from: 'care_receiver[birthday(2i)]'
            select care_receiver.birthday.strftime('%-d'), from: 'care_receiver[birthday(3i)]'
            click_on '新規登録'
          end

          it_behaves_like 'Form input button test', 'last_name', '入力してください'
        end
      end
    end

    # 名前 ============================================================================
    describe 'input: first_name', js: true do
      let(:care_receiver) { build(:care_receiver) }
      let(:valid_value) { care_receiver.first_name } # shared_examplesで使用

      subject { page }

      include_context 'Page transition to new_care_receiver'

      context '名前を入力しなかった場合' do
        it_behaves_like 'Form input focus test', 'first_name', '', '入力してください'

        context '新規登録ボタンを押したとき' do
          before do
            fill_in 'care_receiver[last_name]', with: care_receiver.last_name
            # 'care_receiver[first_name]' 入力しない
            fill_in 'care_receiver[last_name_kana]', with: care_receiver.last_name_kana
            fill_in 'care_receiver[first_name_kana]', with: care_receiver.first_name_kana
            select care_receiver.birthday.strftime('%Y'), from: 'care_receiver[birthday(1i)]'
            select care_receiver.birthday.strftime('%-m'), from: 'care_receiver[birthday(2i)]'
            select care_receiver.birthday.strftime('%-d'), from: 'care_receiver[birthday(3i)]'
            click_on '新規登録'
          end

          it_behaves_like 'Form input button test', 'first_name', '入力してください'
        end
      end
    end

    # みょうじ =======================================================================================
    describe 'input: last_name_kana', js: true do
      shared_context 'Set of forms, violating last_name_kana' do |violate_value|
        before do
          fill_in 'care_receiver[last_name]', with: care_receiver.last_name
          fill_in 'care_receiver[first_name]', with: care_receiver.first_name
          fill_in 'care_receiver[last_name_kana]', with: violate_value
          fill_in 'care_receiver[first_name_kana]', with: care_receiver.first_name_kana
          select care_receiver.birthday.strftime('%Y'), from: 'care_receiver[birthday(1i)]'
          select care_receiver.birthday.strftime('%-m'), from: 'care_receiver[birthday(2i)]'
          select care_receiver.birthday.strftime('%-d'), from: 'care_receiver[birthday(3i)]'
          click_on '新規登録'
        end
      end

      let(:care_receiver) { build(:care_receiver) }
      let(:valid_value) { care_receiver.last_name_kana } # shared_examplesで使用

      subject { page }

      include_context 'Page transition to new_care_receiver'

      context 'みょうじを入力しなかった場合' do
        it_behaves_like 'Form input focus test', 'last_name_kana', '', '入力してください'

        context '新規登録ボタンを押したとき' do
          before do
            fill_in 'care_receiver[last_name]', with: care_receiver.last_name
            fill_in 'care_receiver[first_name]', with: care_receiver.first_name
            # 'care_receiver[last_name_kana]' 入力しない
            fill_in 'care_receiver[first_name_kana]', with: care_receiver.first_name_kana
            select care_receiver.birthday.strftime('%Y'), from: 'care_receiver[birthday(1i)]'
            select care_receiver.birthday.strftime('%-m'), from: 'care_receiver[birthday(2i)]'
            select care_receiver.birthday.strftime('%-d'), from: 'care_receiver[birthday(3i)]'
            click_on '新規登録'
          end

          it_behaves_like 'Form input button test', 'last_name_kana', '入力してください'
        end
      end

      context 'みょうじを漢字で入力した場合' do
        it_behaves_like 'Form input focus test', 'last_name_kana', Gimei.last.kanji, 'ひらがなで入力してください'

        context '新規登録ボタンを押したとき' do
          include_context 'Set of forms, violating last_name_kana', Gimei.last.kanji

          it_behaves_like 'Form input button test', 'last_name_kana', 'ひらがなで入力してください'
        end
      end

      context 'みょうじをカタカナで入力した場合' do
        it_behaves_like 'Form input focus test', 'last_name_kana', Gimei.last.katakana, 'ひらがなで入力してください'

        context '新規登録ボタンを押したとき' do
          include_context 'Set of forms, violating last_name_kana', Gimei.last.katakana

          it_behaves_like 'Form input button test', 'last_name_kana', 'ひらがなで入力してください'
        end
      end

      context 'みょうじをローマ字で入力した場合' do
        it_behaves_like 'Form input focus test', 'last_name_kana', Gimei.last.romaji, 'ひらがなで入力してください'

        context '新規登録ボタンを押したとき' do
          include_context 'Set of forms, violating last_name_kana', Gimei.last.romaji

          it_behaves_like 'Form input button test', 'last_name_kana', 'ひらがなで入力してください'
        end
      end

      context 'みょうじを記号を含んだ文字で入力した場合' do
        it_behaves_like 'Form input focus test', 'last_name_kana', "@#{Gimei.last.hiragana}", 'ひらがなで入力してください'

        context '新規登録ボタンを押したとき' do
          include_context 'Set of forms, violating last_name_kana', "@#{Gimei.last.hiragana}"

          it_behaves_like 'Form input button test', 'last_name_kana', 'ひらがなで入力してください'
        end
      end
    end

    # なまえ ======================================================================================================
    describe 'input: first_name_kana', js: true do
      shared_context 'Set of forms, violating first_name_kana' do |violate_value|
        before do
          fill_in 'care_receiver[last_name]', with: care_receiver.last_name
          fill_in 'care_receiver[first_name]', with: care_receiver.first_name
          fill_in 'care_receiver[last_name_kana]', with: care_receiver.last_name_kana
          fill_in 'care_receiver[first_name_kana]', with: violate_value
          select care_receiver.birthday.strftime('%Y'), from: 'care_receiver[birthday(1i)]'
          select care_receiver.birthday.strftime('%-m'), from: 'care_receiver[birthday(2i)]'
          select care_receiver.birthday.strftime('%-d'), from: 'care_receiver[birthday(3i)]'
          click_on '新規登録'
        end
      end

      let(:care_receiver) { build(:care_receiver) }
      let(:valid_value) { care_receiver.first_name_kana } # shared_examplesで使用

      subject { page }

      include_context 'Page transition to new_care_receiver'

      context 'なまえを何も入力せず、フォーカスを外した場合' do
        it_behaves_like 'Form input focus test', 'first_name_kana', '', '入力してください'

        context 'なまえを入力せず、新規登録ボタンを押した場合' do
          before do
            fill_in 'care_receiver[last_name]', with: care_receiver.last_name
            fill_in 'care_receiver[first_name]', with: care_receiver.first_name
            fill_in 'care_receiver[last_name_kana]', with: care_receiver.last_name_kana
            # 'care_receiver[first_name_kana]' 入力しない
            select care_receiver.birthday.strftime('%Y'), from: 'care_receiver[birthday(1i)]'
            select care_receiver.birthday.strftime('%-m'), from: 'care_receiver[birthday(2i)]'
            select care_receiver.birthday.strftime('%-d'), from: 'care_receiver[birthday(3i)]'
            click_on '新規登録'
          end

          it_behaves_like 'Form input button test', 'first_name_kana', '入力してください'
        end
      end

      context 'なまえを漢字で入力した場合' do
        it_behaves_like 'Form input focus test', 'first_name_kana', Gimei.first.kanji, 'ひらがなで入力してください'

        context '新規登録ボタンを押したとき' do
          include_context 'Set of forms, violating first_name_kana', Gimei.first.kanji

          it_behaves_like 'Form input button test', 'first_name_kana', 'ひらがなで入力してください'
        end
      end

      context 'なまえをカタカナで入力した場合' do
        it_behaves_like 'Form input focus test', 'first_name_kana', Gimei.first.katakana, 'ひらがなで入力してください'

        context '新規登録ボタンを押したとき' do
          include_context 'Set of forms, violating first_name_kana', Gimei.first.katakana

          it_behaves_like 'Form input button test', 'first_name_kana', 'ひらがなで入力してください'
        end
      end

      context 'なまえをローマ字で入力した場合' do
        it_behaves_like 'Form input focus test', 'first_name_kana', Gimei.first.romaji, 'ひらがなで入力してください'

        context '新規登録ボタンを押したとき' do
          include_context 'Set of forms, violating first_name_kana', Gimei.first.romaji

          it_behaves_like 'Form input button test', 'first_name_kana', 'ひらがなで入力してください'
        end
      end

      context 'なまえを記号を含んだ文字で入力した場合' do
        it_behaves_like 'Form input focus test', 'first_name_kana', "@#{Gimei.first.hiragana}", 'ひらがなで入力してください'

        context '新規登録ボタンを押したとき' do
          include_context 'Set of forms, violating first_name_kana', "@#{Gimei.first.hiragana}"

          it_behaves_like 'Form input button test', 'first_name_kana', 'ひらがなで入力してください'
        end
      end
    end

    # 生年月日(年) ========================================================================================
    describe 'input: 生年月日', js: true do
      subject { page }

      include_context 'Page transition to new_care_receiver'

      context '年が選択されていなかった場合' do
        include_context 'Form select focus test', '1i', Faker::Date.birthday(max_age: 150).strftime('%Y')

        context '月の選択をせず、エラーが出ていたとき' do
          before do
            find('#care_receiver_birthday_2i').click
            select '', from: 'care_receiver[birthday(2i)]'
            find('.new-care_receiver-title').click # フォーカスはずし
          end

          include_context 'Form select focus test, if there are other errors', '1i', Faker::Date.birthday(max_age: 150).strftime('%Y')
        end

        context '日の選択をせず、エラーが出ていたとき' do
          before do
            find('#care_receiver_birthday_3i').click
            select '', from: 'care_receiver[birthday(3i)]'
            find('.new-care_receiver-title').click # フォーカスはずし
          end

          include_context 'Form select focus test, if there are other errors', '1i', Faker::Date.birthday(max_age: 150).strftime('%Y')
        end

        context '新規登録ボタンを押したとき' do
          let(:care_receiver) { build(:care_receiver) }

          before do
            fill_in 'care_receiver[last_name]', with: care_receiver.last_name
            fill_in 'care_receiver[first_name]', with: care_receiver.first_name
            fill_in 'care_receiver[last_name_kana]', with: care_receiver.last_name_kana
            fill_in 'care_receiver[first_name_kana]', with: care_receiver.first_name_kana
            # 'care_receiver[birthday(1i)]' 選択しない。
            select care_receiver.birthday.strftime('%-m'), from: 'care_receiver[birthday(2i)]'
            select care_receiver.birthday.strftime('%-d'), from: 'care_receiver[birthday(3i)]'
            click_on '新規登録'
          end

          include_context 'Form select button test', '1i', Faker::Date.birthday(max_age: 150).strftime('%Y')
        end
      end

      context '月が選択されていなかった場合' do
        include_context 'Form select focus test', '2i', Faker::Date.birthday.strftime('%-m')

        context '年の選択をせず、エラーが出ていたとき' do
          before do
            find('#care_receiver_birthday_1i').click
            select '', from: 'care_receiver[birthday(1i)]'
            find('.new-care_receiver-title').click # フォーカスはずし
          end

          include_context 'Form select focus test, if there are other errors', '2i', Faker::Date.birthday.strftime('%-m')
        end

        context '日の選択をせず、エラーが出ていたとき' do
          before do
            find('#care_receiver_birthday_3i').click
            select '', from: 'care_receiver[birthday(3i)]'
            find('.new-care_receiver-title').click # フォーカスはずし
          end

          include_context 'Form select focus test, if there are other errors', '2i', Faker::Date.birthday.strftime('%-m')
        end

        context '新規登録ボタンを押したとき' do
          let(:care_receiver) { build(:care_receiver) }

          before do
            fill_in 'care_receiver[last_name]', with: care_receiver.last_name
            fill_in 'care_receiver[first_name]', with: care_receiver.first_name
            fill_in 'care_receiver[last_name_kana]', with: care_receiver.last_name_kana
            fill_in 'care_receiver[first_name_kana]', with: care_receiver.first_name_kana
            select care_receiver.birthday.strftime('%Y'), from: 'care_receiver[birthday(1i)]'
            # 'care_receiver[birthday(2i)]' 選択しない。
            select care_receiver.birthday.strftime('%-d'), from: 'care_receiver[birthday(3i)]'
            click_on '新規登録'
          end

          include_context 'Form select button test', '2i', Faker::Date.birthday.strftime('%-m')
        end
      end

      context '日が選択されていなかった場合' do
        include_context 'Form select focus test', '3i', Faker::Date.birthday.strftime('%-d')

        context '年の選択をせず、エラーが出ていたとき' do
          before do
            find('#care_receiver_birthday_1i').click
            select '', from: 'care_receiver[birthday(1i)]'
            find('.new-care_receiver-title').click # フォーカスはずし
          end

          include_context 'Form select focus test, if there are other errors', '3i', Faker::Date.birthday.strftime('%-d')
        end

        context '月の選択をせず、エラーが出ていたとき' do
          before do
            find('#care_receiver_birthday_2i').click
            select '', from: 'care_receiver[birthday(2i)]'
            find('.new-care_receiver-title').click # フォーカスはずし
          end

          include_context 'Form select focus test, if there are other errors', '3i', Faker::Date.birthday.strftime('%-d')
        end

        context '新規登録ボタンを押したとき' do
          let(:care_receiver) { build(:care_receiver) }

          before do
            fill_in 'care_receiver[last_name]', with: care_receiver.last_name
            fill_in 'care_receiver[first_name]', with: care_receiver.first_name
            fill_in 'care_receiver[last_name_kana]', with: care_receiver.last_name_kana
            fill_in 'care_receiver[first_name_kana]', with: care_receiver.first_name_kana
            select care_receiver.birthday.strftime('%Y'), from: 'care_receiver[birthday(1i)]'
            select care_receiver.birthday.strftime('%-m'), from: 'care_receiver[birthday(2i)]'
            # 'care_receiver[birthday(3i)]' 選択しない。
            click_on '新規登録'
          end

          include_context 'Form select button test', '3i', Faker::Date.birthday.strftime('%-d')
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
