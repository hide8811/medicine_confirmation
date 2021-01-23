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
      click_on '編集', class: 'show-care_receiver__dosing_time--edit--button'
    end

    subject { current_path }

    context '戻るボタンを押した時' do
      it 'ご利用者様詳細画面に戻ること' do
        click_on '戻る'
        is_expected.to eq care_receiver_path(care_receiver.id)
      end
    end

    context '薬 新規登録ボタンを押した時' do
      it '薬新規登録画面に遷移すること' do
        click_on '薬 新規登録'
        is_expected.to eq medicines_path
      end
    end

    context 'ホーム画面ボタンを押した時' do
      it 'ホーム画面に遷移すること' do
        click_on 'ホーム画面'
        is_expected.to eq root_path
      end
    end
  end

  describe '服薬時間' do
    subject { page }

    describe '表示' do
      context '服薬時間が登録されていない時' do
        it 'ページ遷移後、データが表示されないこと' do
          visit care_receiver_path(care_receiver.id)
          click_on '編集', class: 'show-care_receiver__dosing_time--edit--button'
          is_expected.to have_content '服薬はありません'
        end
      end

      context '服薬時間が登録されている時' do
        let!(:dosing_time_am) { create(:dosing_time, timeframe: '朝食後', care_receiver_id: care_receiver.id) }
        let!(:dosing_tiem_pm) { create(:dosing_time, timeframe: '夕食後', care_receiver_id: care_receiver.id) }

        before do
          visit care_receiver_path(care_receiver.id)
          click_on '編集', class: 'show-care_receiver__dosing_time--edit--button'
        end

        it { is_expected.to have_selector '.timeframe-dosing_time__name', text: dosing_time_am.timeframe }

        it { is_expected.to have_selector '.timeframe-dosing_time__time', text: dosing_time_am.time.strftime('%-H:%-M') }

        it { is_expected.to have_css '.timeframe-dosing_time__name', count: 2 }
      end
    end

    describe '追加' do
      context '登録内容を選択する時' do
        let!(:dosing_time) { create(:dosing_time, timeframe: '朝食後', care_receiver_id: care_receiver.id) }

        before do
          visit care_receiver_path(care_receiver.id)
          click_on '編集', class: 'show-care_receiver__dosing_time--edit--button'
        end

        # js で実装
        context '服薬時間帯を選択した時' do
          it 'デフォルトの時間が表示されること' do
            # select '昼食後', from: 'dosing_time[timeframe]'
            # is_expected.to have_selector '', text: ''
          end
        end

        context 'すでに登録した時間帯がある時' do
          it { is_expected.not_to have_select 'dosing_time[timeframe]', options: [dosing_time.timeframe] }
        end
      end

      context '選択した内容を登録する時' do
        before do
          visit care_receiver_path(care_receiver.id)
          click_on '編集', class: 'show-care_receiver__dosing_time--edit--button'
        end

        context '登録が成功する時' do
          before do
            select '朝食後', from: 'dosing_time[timeframe]'
            select '07', from: 'dosing_time[time(4i)]'
            select '30', from: 'dosing_time[time(5i)]'
            click_on '追加', class: 'new-timeframe-dosing_time__submit--btn'
          end

          it { is_expected.to have_selector '.timeframe-dosing_time__name', text: '朝食後' }

          it { is_expected.to have_selector '.timeframe-dosing_time__time', text: '7:30' }

          it { is_expected.not_to have_select 'dosing_time[timeframe]', with_options: ['朝食後'] }
        end

        # js で実装
        context '登録が失敗する時' do
          context '時間帯が未選択の時' do
            it 'エラー分が出ること' do
            end

            it 'submitできないこと' do
            end
          end

          context '時間が未選択の時' do
            it 'エラー分が出ること' do
            end

            it 'submitできないこと' do
            end
          end

          context '時間帯がすでに存在している時' do
            it 'エラー分が出ること' do
            end

            it 'submitできないこと' do
            end
          end
        end
      end
    end

    # discard で実装
    # describe '削除' do
    #   let!(:dosing_time) { create(:dosing_time) }
    #   let!(:medicine) { create(:medicine) }

    #   before do
    #     create(:medicine_dosing_time, dosing_time_id: dosing_time.id, medicine_id: medicine.id)
    #     visit care_receiver_path(care_receiver.id)
    #     click_on '編集', class: '.show-care_receiver__dosing_time--edit--button'
    #   end

    #   context '削除ボタンを押した時' do
    #     it '表示されていた内容が消えること' do
    #       click_on '削除', class: ''
    #       is_expected.not_to have_selector '', text: '朝食後'
    #     end
    #   end
    # end
  end

  describe '薬' do
    subject { page }

    describe '表示' do
      let!(:dosing_time_am) { create(:dosing_time, timeframe: '朝食後', care_receiver_id: care_receiver.id) }
      let!(:dosing_time_pm) { create(:dosing_time, timeframe: '夕食後', care_receiver_id: care_receiver.id) }

      context 'medicinesテーブルの全てのカラムに値が入っている時' do
        let!(:medicine_A) { create(:medicine, name: '薬A') }
        let!(:medicine_B) { create(:medicine, name: '薬B') }

        before do
          create(:medicine_dosing_time, dosing_time_id: dosing_time_am.id, medicine_id: medicine_A.id)
          create(:medicine_dosing_time, dosing_time_id: dosing_time_am.id, medicine_id: medicine_B.id)
          create(:medicine_dosing_time, dosing_time_id: dosing_time_pm.id, medicine_id: medicine_A.id)

          visit care_receiver_path(care_receiver.id)
          click_on '編集', class: 'show-care_receiver__dosing_time--edit--button'
        end

        it { is_expected.to have_selector '.list-medicine-dosing_time__item--name', text: medicine_A.name }

        it { is_expected.to have_css '.list-medicine-dosing_time__item--image' }

        it { is_expected.to have_css '.list-medicine-dosing_time__item', count: 3 }
      end

      context 'medicinesテーブルのimageカラムに値が入っていない時' do
        let!(:medicine_A) { create(:medicine, name: '薬A', image: '') }
        let!(:medicine_B) { create(:medicine, name: '薬B', image: '') }

        before do
          create(:medicine_dosing_time, dosing_time_id: dosing_time_am.id, medicine_id: medicine_A.id)
          create(:medicine_dosing_time, dosing_time_id: dosing_time_am.id, medicine_id: medicine_B.id)
          create(:medicine_dosing_time, dosing_time_id: dosing_time_pm.id, medicine_id: medicine_A.id)

          visit care_receiver_path(care_receiver.id)
          click_on '編集', class: 'show-care_receiver__dosing_time--edit--button'
        end

        it { is_expected.to have_selector '.list-medicine-dosing_time__item--name', text: medicine_A.name }

        it { is_expected.to have_css '.list-medicine-dosing_time__item--no-image' }

        it { is_expected.to have_css '.list-medicine-dosing_time__item', count: 3 }
      end
    end

    describe '追加' do
      let!(:dosing_time) { create(:dosing_time, timeframe: '朝食後', care_receiver_id: care_receiver.id) }
      let!(:other_dosing_time) { create(:dosing_time, timeframe: '夕食後', care_receiver_id: care_receiver.id) }
      let!(:medicine) { create(:medicine) }

      before do
        visit care_receiver_path(care_receiver.id)
        click_on '編集', class: 'show-care_receiver__dosing_time--edit--button'

        select medicine.name, from: "new-medicine-#{dosing_time.id}"
        click_on '追加', id: "new-medicine-#{dosing_time.id}-submit"
      end

      context '薬を追加する時間帯' do
        it { is_expected.to have_selector "#medicine-#{medicine.id}-#{dosing_time.id}__name", text: medicine.name }

        it { is_expected.not_to have_select "new-medicine-#{dosing_time.id}", with_options: [medicine.name] }
      end

      context '薬を追加していない時間帯の場合' do
        it { is_expected.not_to have_css "#medicine-#{medicine.id}-#{other_dosing_time.id}" }

        it { is_expected.to have_select "new-medicine-#{other_dosing_time.id}", with_options: [medicine.name] }
      end
    end

    # discard で実装
    # describe '削除' do
    #   let!(:dosing_time) { create(:dosing_time) }
    #   let!(:medicine) { create(:medicine) }

    #   before do
    #     create(:medicine_dosing_time, dosing_time_id: dosing_time.id, medicine_id: medicine.id)
    #     visit care_receiver_path(care_receiver.id)
    #     click_on '編集', class: 'show-care_receiver__dosing_time--edit--button'
    #   end

    #   it '表示されていた内容が消えること' do
    #     click_on '削除', class: ''
    #     is_expected.not_to have_selector '', text: dosing_time.timeframe
    #   end
    # end
  end
end
