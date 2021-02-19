require 'rails_helper'

RSpec.describe 'DosingTimes', type: :system do
  before do
    user = create(:user)
    login_as(user, scope: :user)
  end

  let!(:care_receiver) { create(:care_receiver) }

  describe 'サイドメニュー' do
    before do
      visit care_receiver_path(care_receiver.id)
      click_on '編集', class: 'dosing_time-show_care_receiver__edit--btn'
    end

    subject { current_path }

    context '戻るボタンを押した場合' do
      it 'ご利用者様詳細画面に戻ること' do
        click_on '戻る'
        is_expected.to eq care_receiver_path(care_receiver)
      end
    end

    context '薬 新規登録ボタンを押した場合' do
      it '薬新規登録画面に遷移すること' do
        click_on '薬 新規登録'
        is_expected.to eq medicines_path
      end
    end

    context 'ホームボタンを押した場合' do
      it 'ホーム画面に遷移すること' do
        click_on 'ホーム'
        is_expected.to eq root_path
      end
    end
  end

  describe '服薬時間' do
    subject { page }

    describe '表示 :index' do
      context '服薬時間が登録されていない場合' do
        it 'ページ遷移後、データが表示されないこと' do
          visit care_receiver_path(care_receiver.id)
          click_on '編集', class: 'dosing_time-show_care_receiver__edit--btn'
          is_expected.to have_content '服薬はありません'
        end
      end

      context '服薬時間が登録されている場合' do
        let!(:dosing_time) { create(:dosing_time, timeframe_id: 1, care_receiver_id: care_receiver.id) }

        before do
          visit care_receiver_path(care_receiver.id)
          click_on '編集', class: 'dosing_time-show_care_receiver__edit--btn'
        end

        it { is_expected.to have_selector '.timeframe-dosing_time__name', text: dosing_time.timeframe.name }

        it { is_expected.to have_selector '.timeframe-dosing_time__time', text: dosing_time.time.strftime('%-H:%0M') }
      end

      context '複数の服薬時間が登録されている場合' do
        let!(:after_lunch) { create(:dosing_time, timeframe_id: 10, care_receiver_id: care_receiver.id) }
        let!(:after_dinner) { create(:dosing_time, timeframe_id: 15, care_receiver_id: care_receiver.id) }
        let!(:after_breakfast) { create(:dosing_time, timeframe_id: 5, care_receiver_id: care_receiver.id) }
        let!(:before_sleeping) { create(:dosing_time, timeframe_id: 17, care_receiver_id: care_receiver.id) }

        before do
          visit care_receiver_path(care_receiver.id)
          click_on '編集', class: 'dosing_time-show_care_receiver__edit--btn'
        end

        it { is_expected.to have_css '.timeframe-dosing_time__name', count: 4 }

        it '時間帯順に並んでいること' do
          aggregate_failures do
            expect(page.all('.timeframe-dosing_time__name')[0]).to have_content after_breakfast.timeframe.name
            expect(page.all('.timeframe-dosing_time__name')[1]).to have_content after_lunch.timeframe.name
            expect(page.all('.timeframe-dosing_time__name')[2]).to have_content after_dinner.timeframe.name
            expect(page.all('.timeframe-dosing_time__name')[3]).to have_content before_sleeping.timeframe.name
          end
        end
      end
    end

    describe '追加 :create' do
      describe '選択' do
        context '服薬時間帯を選択した場合', js: true do
          let(:timeframe) { Timeframe.all.sample }
          let(:timeframe_hour) { Time.parse(timeframe.time).strftime('%H') }
          let(:timeframe_minute) { Time.parse(timeframe.time).strftime('%M') }

          before do
            visit care_receiver_path(care_receiver.id)
            click_on '編集', class: 'dosing_time-show_care_receiver__edit--btn'

            select timeframe.name, from: 'dosing_time[timeframe_id]'
          end

          it { is_expected.to have_select 'dosing_time[time(4i)]', selected: timeframe_hour }

          it { is_expected.to have_select 'dosing_time[time(5i)]', selected: timeframe_minute }
        end

        context 'すでに登録した時間帯がある場合' do
          let!(:dosing_time) { create(:dosing_time, timeframe_id: 1, care_receiver_id: care_receiver.id) }

          before do
            visit care_receiver_path(care_receiver.id)
            click_on '編集', class: 'dosing_time-show_care_receiver__edit--btn'
          end

          it { is_expected.not_to have_select 'dosing_time[timeframe_id]', options: [dosing_time.timeframe.name] }
        end
      end

      describe '登録' do
        before do
          visit care_receiver_path(care_receiver.id)
          click_on '編集', class: 'dosing_time-show_care_receiver__edit--btn'
        end

        context '登録が成功する場合' do
          before do
            select '朝食後', from: 'dosing_time[timeframe_id]'
            select '07', from: 'dosing_time[time(4i)]'
            select '30', from: 'dosing_time[time(5i)]'
            click_on '追加', class: 'new-timeframe-dosing_time__submit--btn'
          end

          it { is_expected.to have_selector '.timeframe-dosing_time__name', text: '朝食後' }

          it { is_expected.to have_selector '.timeframe-dosing_time__time', text: '7:30' }

          it { is_expected.not_to have_select 'dosing_time[timeframe_id]', with_options: ['朝食後'] }
        end

        context '登録が失敗する場合', js: true do
          context '時間帯が未選択のとき' do
            before do
              select '--', from: 'dosing_time[timeframe_id]'
              select '07', from: 'dosing_time[time(4i)]'
              select '30', from: 'dosing_time[time(5i)]'
              click_on '追加', class: 'new-timeframe-dosing_time__submit--btn'
            end

            it { is_expected.to have_content '時間帯を選択してください' }

            it { is_expected.to have_selector '#new-dosing_time-timeframe-select', class: 'error-frame' }

            it { is_expected.not_to have_selector '.timeframe-dosing_time__name', text: '朝食後' }

            context '時間帯を選択し直したとき' do
              before { select '朝食後', from: 'dosing_time[timeframe_id]' }

              it { is_expected.not_to have_content '時間帯を選択してください' }

              it { is_expected.not_to have_selector '#new-dosing_time-timeframe-select', class: 'error-frame' }

              context '選択後、再び追加ボタンを押したとき' do
                before { click_on '追加', class: 'new-timeframe-dosing_time__submit--btn' }

                it { is_expected.to have_selector '.timeframe-dosing_time__name', text: '朝食後' }
              end
            end
          end

          context '時間(時)が未選択のとき' do
            before do
              select '朝食後', from: 'dosing_time[timeframe_id]'
              select '--', from: 'dosing_time[time(4i)]'
              select '30', from: 'dosing_time[time(5i)]'
              click_on '追加', class: 'new-timeframe-dosing_time__submit--btn'
            end

            it { is_expected.to have_content '時間(時)を選択してください' }

            it { is_expected.to have_selector '#dosing_time_time_4i', class: 'error-frame' }

            it { is_expected.not_to have_selector '.timeframe-dosing_time__name', text: '朝食後' }

            context '時間(時)を選択したとき' do
              before { select '07', from: 'dosing_time[time(4i)]' }

              it { is_expected.not_to have_content '時間(時)を選択してください' }

              it { is_expected.not_to have_selector '#dosing_time_time_4i', class: 'error-frame' }

              context '選択後、再び追加ボタンを押したとき' do
                before { click_on '追加', class: 'new-timeframe-dosing_time__submit--btn' }

                it { is_expected.to have_selector '.timeframe-dosing_time__name', text: '朝食後' }
              end
            end
          end

          context '時間(分)が未選択のとき' do
            before do
              select '朝食後', from: 'dosing_time[timeframe_id]'
              select '07', from: 'dosing_time[time(4i)]'
              select '--', from: 'dosing_time[time(5i)]'
              click_on '追加', class: 'new-timeframe-dosing_time__submit--btn'
            end

            it { is_expected.to have_content '時間(分)を選択してください' }

            it { is_expected.to have_selector '#dosing_time_time_5i', class: 'error-frame' }

            it { is_expected.not_to have_selector '.timeframe-dosing_time__name', text: '朝食後' }

            context '時間(分)を選択したとき' do
              before { select '30', from: 'dosing_time[time(5i)]' }

              it { is_expected.not_to have_content '時間(分)を選択してください' }

              it { is_expected.not_to have_selector '#dosing_time_time_5i', class: 'error-frame' }

              context '選択後、再び追加ボタンを押したとき' do
                before { click_on '追加', class: 'new-timeframe-dosing_time__submit--btn' }

                it { is_expected.to have_selector '.timeframe-dosing_time__name', text: '朝食後' }
              end
            end
          end
        end
      end
    end

    describe '削除 :destroy', js: true do
      let!(:dosing_time) { create(:dosing_time, care_receiver_id: care_receiver.id) }
      let!(:medicine) { create(:medicine) }

      before do
        create(:medicine_dosing_time, dosing_time_id: dosing_time.id, medicine_id: medicine.id)
        visit care_receiver_path(care_receiver.id)
        click_on '編集', class: 'dosing_time-show_care_receiver__edit--btn'
      end

      context '削除ボタンを押した場合' do
        before { click_on '削除', id: "delete-dosing_time-#{dosing_time.id}" }

        it { expect(page.accept_confirm).to eq "服薬時間帯【 #{dosing_time.timeframe.name} 】を本当に削除しますか？" }
      end

      context '削除した場合' do
        before { accept_confirm { click_on '削除', id: "delete-dosing_time-#{dosing_time.id}" } }

        it { is_expected.not_to have_css "dosing_time-#{dosing_time.id}" }

        it { is_expected.to have_select 'dosing_time[timeframe_id]', with_options: [dosing_time.timeframe.name] }

        it '削除した時間帯と同じ名前の時間帯が再び登録できること' do
          select '朝食後', from: 'dosing_time[timeframe_id]'
          select '07', from: 'dosing_time[time(4i)]'
          select '30', from: 'dosing_time[time(5i)]'
          click_on '追加', class: 'new-timeframe-dosing_time__submit--btn'
          is_expected.to have_selector '.timeframe-dosing_time__name', text: '朝食後'
        end
      end

      context '削除をキャンセルした場合' do
        before { dismiss_confirm { click_on '削除', id: "delete-dosing_time-#{dosing_time.id}" } }

        it { is_expected.to have_selector '.timeframe-dosing_time__name', text: dosing_time.timeframe.name }

        it { is_expected.not_to have_select 'dosing_time[timeframe_id]', with_options: [dosing_time.timeframe.name] }
      end
    end
  end

  describe '薬' do
    subject { page }

    describe '表示' do
      let!(:dosing_time_am) { create(:dosing_time, timeframe_id: 1, care_receiver_id: care_receiver.id) }
      let!(:dosing_time_pm) { create(:dosing_time, timeframe_id: 2, care_receiver_id: care_receiver.id) }

      context 'medicinesテーブルの全てのカラムに値が入っている場合' do
        let!(:medicine_A) { create(:medicine, name: '薬A') }
        let!(:medicine_B) { create(:medicine, name: '薬B') }

        before do
          create(:medicine_dosing_time, dosing_time_id: dosing_time_am.id, medicine_id: medicine_A.id)
          create(:medicine_dosing_time, dosing_time_id: dosing_time_am.id, medicine_id: medicine_B.id)
          create(:medicine_dosing_time, dosing_time_id: dosing_time_pm.id, medicine_id: medicine_A.id)

          visit care_receiver_path(care_receiver.id)
          click_on '編集', class: 'dosing_time-show_care_receiver__edit--btn'
        end

        it { is_expected.to have_selector "#medicine-#{medicine_A.id}-#{dosing_time_am.id}__name", text: medicine_A.name }

        it { is_expected.to have_css "#medicine-#{medicine_A.id}-#{dosing_time_am.id}__image" }

        it { is_expected.to have_css '.medicine-dosing_time-item', count: 3 }
      end

      context 'medicinesテーブルのimageカラムに値が入っていない場合' do
        let!(:medicine_A) { create(:medicine, name: '薬A', image: '') }
        let!(:medicine_B) { create(:medicine, name: '薬B', image: '') }

        before do
          create(:medicine_dosing_time, dosing_time_id: dosing_time_am.id, medicine_id: medicine_A.id)
          create(:medicine_dosing_time, dosing_time_id: dosing_time_am.id, medicine_id: medicine_B.id)
          create(:medicine_dosing_time, dosing_time_id: dosing_time_pm.id, medicine_id: medicine_A.id)

          visit care_receiver_path(care_receiver.id)
          click_on '編集', class: 'dosing_time-show_care_receiver__edit--btn'
        end

        it { is_expected.to have_selector "#medicine-#{medicine_A.id}-#{dosing_time_am.id}__name", text: medicine_A.name }

        it { is_expected.to have_css '.medicine-dosing_time-item__no-image' }

        it { is_expected.to have_css '.medicine-dosing_time-item', count: 3 }
      end
    end

    describe '追加 medicine_dosing_time: :create' do
      let!(:dosing_time) { create(:dosing_time, timeframe_id: 1, care_receiver_id: care_receiver.id) }
      let!(:other_dosing_time) { create(:dosing_time, timeframe_id: 2, care_receiver_id: care_receiver.id) }
      let!(:medicine) { create(:medicine) }

      before do
        visit care_receiver_path(care_receiver.id)
        click_on '編集', class: 'dosing_time-show_care_receiver__edit--btn'
      end

      context '薬を選択し、追加が成功した場合' do
        before do
          select medicine.name, from: "new-medicine-#{dosing_time.id}"
          click_on '追加', id: "new-medicine-#{dosing_time.id}-submit"
        end

        context '薬を追加する時間帯のとき' do
          it { is_expected.to have_selector "#medicine-#{medicine.id}-#{dosing_time.id}__name", text: medicine.name }

          it { is_expected.not_to have_select "new-medicine-#{dosing_time.id}", with_options: [medicine.name] }
        end

        context '薬を追加していない時間帯のとき' do
          it { is_expected.not_to have_css "#medicine-#{medicine.id}-#{other_dosing_time.id}" }

          it { is_expected.to have_select "new-medicine-#{other_dosing_time.id}", with_options: [medicine.name] }
        end
      end

      context '薬を選択せず、追加が失敗した場合', js: true do
        before { click_on '追加', id: "new-medicine-#{dosing_time.id}-submit" }

        it { is_expected.to have_selector "#new-medicine_dosing_time-#{dosing_time.id}-error-message", text: '薬を選択してください' }

        it { is_expected.to have_selector "#new-medicine-#{dosing_time.id}", class: 'error-frame' }

        it { is_expected.not_to have_selector "#medicine-#{medicine.id}-#{dosing_time.id}__name", text: medicine.name }

        context '薬を選択し直したとき' do
          before { select medicine.name, from: "new-medicine-#{dosing_time.id}" }

          it { is_expected.not_to have_selector '#new-medicine_dosing_time-error-message', text: '薬を選択してください' }

          it { is_expected.not_to have_selector "#new-medicine-#{dosing_time.id}", class: 'error-frame' }

          context '薬を選択後、再び追加ボタンを押したとき' do
            before { click_on '追加', id: "new-medicine-#{dosing_time.id}-submit" }

            it { is_expected.not_to have_selector "#medicine-#{medicine.id}-#{dosing_time.id}__name", text: medicine.name }
          end
        end
      end
    end

    describe '削除 medicine_dosign_time: :destroy', js: true do
      let!(:dosing_time) { create(:dosing_time, care_receiver_id: care_receiver.id) }
      let!(:medicine) { create(:medicine) }
      let!(:medicine_dosing_time) { create(:medicine_dosing_time, dosing_time_id: dosing_time.id, medicine_id: medicine.id) }

      before do
        visit care_receiver_path(care_receiver.id)
        click_on '編集', class: 'dosing_time-show_care_receiver__edit--btn'
      end

      context '削除ボタンを押した時' do
        before { click_on '削除', id: "delete-medicine_dosing_time-#{medicine.id}-#{dosing_time.id}" }

        it { expect(page.accept_confirm).to eq "【 #{dosing_time.timeframe.name} 】の薬【 #{medicine.name} 】を本当に削除しますか？" }
      end

      context '削除した時' do
        before { accept_confirm { click_on '削除', id: "delete-medicine_dosing_time-#{medicine.id}-#{dosing_time.id}" } }

        it { is_expected.not_to have_css "#medicine-#{medicine.id}-#{dosing_time.id}" }

        it { is_expected.to have_select "new-medicine-#{dosing_time.id}", with_options: [medicine.name] }

        it '削除した薬と同じ名前の薬が再び登録できること' do
          select medicine.name, from: "new-medicine-#{dosing_time.id}"
          click_on '追加', id: "new-medicine-#{dosing_time.id}-submit"
          is_expected.to have_selector "#medicine-#{medicine.id}-#{dosing_time.id}__name", text: medicine.name
        end
      end

      context '削除をキャンセルした時' do
        before { dismiss_confirm { click_on '削除', id: "delete-medicine_dosing_time-#{medicine.id}-#{dosing_time.id}" } }

        it { is_expected.to have_selector "#medicine-#{medicine.id}-#{dosing_time.id}__name", text: medicine.name }

        it { is_expected.not_to have_select "new-medicine-#{dosing_time.id}", with_options: [medicine.name] }
      end
    end
  end
end
