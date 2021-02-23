require 'rails_helper'

RSpec.describe 'Medicines', type: :system do
  before do
    user = create(:user)
    login_as(user, scope: :user)
  end

  describe 'サイドボタン' do
    context 'ホーム画面から遷移してきた場合' do
      context 'ホームボタンを押そうとしたとき' do
        before do
          visit root_path
          click_on '薬'
        end

        it { expect(page).to have_link 'ホーム' }
        it { expect(page).not_to have_link '戻る' }
      end

      context '遷移後すぐホームボタンを押したとき' do
        before do
          visit root_path
          click_on '薬'

          click_on 'ホーム'
        end

        it { expect(current_path).to eq root_path }
      end

      context '薬を登録後、ホームボタンを押したとき' do
        let(:medicine_name) { Faker::Lorem.word }

        before do
          visit root_path
          click_on '薬'

          fill_in 'medicine[name]', with: medicine_name
          click_on '新規登録'
          find('.medicines_list__item', text: medicine_name)

          click_on 'ホーム'
        end

        it { expect(current_path).to eq root_path }
      end

      context '薬の削除後、ホームボタンを押したとき', js: true do
        let!(:medicine) { create(:medicine) }

        before do
          visit root_path
          click_on '薬'

          accept_confirm { click_on '削除', id: "medicine-#{medicine.id}-delete_btn" }

          click_on 'ホーム'
        end

        it { expect(current_path).to eq root_path }
      end
    end

    context '服薬編集画面から遷移してきた場合' do
      context '戻るボタンを押そうとしたとき' do
        before do
          care_receiver = create(:care_receiver)
          visit care_receiver_dosing_times_path(care_receiver)
          click_on '薬 新規登録'
        end

        it { expect(page).to have_link '戻る' }
        it { expect(page).not_to have_link 'ホーム' }
      end

      context '遷移後すぐ戻るボタンを押したとき' do
        let(:care_receiver) { create(:care_receiver) }

        before do
          visit care_receiver_dosing_times_path(care_receiver)
          click_on '薬 新規登録'
          click_on '戻る'
        end

        it { expect(current_path).to eq care_receiver_dosing_times_path(care_receiver) }
      end

      context '薬を登録後、戻るボタンを押したとき' do
        let(:care_receiver) { create(:care_receiver) }
        let(:medicine_name) { Faker::Lorem.word }

        before do
          visit care_receiver_dosing_times_path(care_receiver)
          click_on '薬 新規登録'

          fill_in 'medicine[name]', with: medicine_name
          click_on '新規登録'
          find('.medicines_list__item', text: medicine_name)

          click_on '戻る'
        end

        it { expect(current_path).to eq care_receiver_dosing_times_path(care_receiver) }
      end

      context '薬の削除後、戻るボタンを押したとき', js: true do
        let(:care_receiver) { create(:care_receiver) }
        let!(:medicine) { create(:medicine) }

        before do
          visit care_receiver_dosing_times_path(care_receiver)
          click_on '薬 新規登録'

          accept_confirm { click_on '削除', id: "medicine-#{medicine.id}-delete_btn" }

          click_on '戻る'
        end

        it { expect(current_path).to eq care_receiver_dosing_times_path(care_receiver) }
      end
    end
  end

  describe '薬一覧表示' do
    it '薬の一覧が表示されること' do
      medicine = create(:medicine)
      visit medicines_path
      expect(page).to have_content medicine.name
    end

    context '薬のデータに画像がある場合' do
      it '画像が表示されること' do
        create(:medicine)
        visit medicines_path
        expect(page).to have_css '.medicines_list__item--image'
      end
    end

    context '薬のデータに画像がない場合' do
      it '画像が表示されないこと' do
        create(:medicine, image: '')
        visit medicines_path
        expect(page).to have_css '.medicines_list__item--no_image'
      end
    end

    context '薬のデータに参考サイトがある場合' do
      it 'サイトへのリンクが表示されること' do
        create(:medicine)
        visit medicines_path
        expect(page).to have_link '参考サイト'
      end
    end

    context '薬のデータに参考サイトがない場合' do
      it 'リンクが表示されないこと' do
        create(:medicine, url: '')
        visit medicines_path
        expect(page).to have_css '.medicines_list__item--no_url'
      end
    end
  end

  describe '新規登録' do
    let(:name) { Faker::Lorem.word }
    let(:image) { 'medicine-test_image.png' }
    let(:image_path) { "#{Rails.root}/spec/factories/image/#{image}" }
    let(:url) { Faker::Internet.url }
    before do
      visit medicines_path
    end

    context '全ての値が入力されている場合' do
      before do
        fill_in 'medicine[name]', with: name
        attach_file 'medicine[image]', image_path
        fill_in 'medicine[url]', with: url
        click_on '登録'
      end

      it { expect(page).to have_selector 'li', text: name }

      it { expect(page).to have_selector "img[src$='#{image}']" }

      it { expect(page).to have_link '参考サイト', href: url }
    end

    context 'input: name' do
      context '空の場合' do
        before do
          fill_in 'medicine[name]', with: ''
          attach_file 'medicine[image]', image_path
          fill_in 'medicine[url]', with: url
          click_on '登録'
        end

        it { expect(page).not_to have_css 'li' }
      end
    end

    context 'input: image' do
      context '空の場合' do
        before do
          fill_in 'medicine[name]', with: name
          # 画像は空
          fill_in 'medicine[url]', with: url
          click_on '登録'
        end

        it { expect(page).to have_selector '.medicines_list__item--name', text: name }

        it { expect(page).to have_css '.medicines_list__item--no_image' }

        it { expect(page).to have_link '参考サイト', href: url }
      end
    end

    context 'input: url' do
      context '空の場合' do
        before do
          fill_in 'medicine[name]', with: name
          attach_file 'medicine[image]', image_path
          fill_in 'medicine[url]', with: ''
          click_on '登録'
        end

        it { expect(page).to have_selector 'li', text: name }

        it { expect(page).to have_selector "img[src$='#{image}']" }

        it { expect(page).to have_css '.medicines_list__item--no_url' }
      end
    end
  end

  describe '論理削除', js: true do
    context '削除ボタンを押したとき' do
      let!(:medicine) { create(:medicine) }

      before do
        visit medicines_path
        click_on '削除', id: "medicine-#{medicine.id}-delete_btn"
      end

      it { expect(page.accept_confirm).to eq "【 #{medicine.name} 】を本当に削除しますか？" }
    end

    context '薬を削除したとき' do
      let(:medicine_a) { create(:medicine) }
      let(:medicine_b) { create(:medicine) }
      let(:after_breakfast) { create(:dosing_time, timeframe_id: 5) }
      let(:before_dinner) { create(:dosing_time, timeframe_id: 12) }
      let!(:after_breakfast_medicine_a) { create(:medicine_dosing_time, medicine: medicine_a, dosing_time: after_breakfast) }
      let!(:after_breakfast_medicine_b) { create(:medicine_dosing_time, medicine: medicine_b, dosing_time: after_breakfast) }
      let!(:before_dinner_medicine_a) { create(:medicine_dosing_time, medicine: medicine_a, dosing_time: before_dinner) }

      before do
        visit medicines_path
        accept_confirm { click_on '削除', id: "medicine-#{medicine_a.id}-delete_btn" }
      end

      it { expect(page).not_to have_content medicine_a.name }

      it '関連したMedicineDosingTimeのデータも論理削除されること' do
        aggregate_failures do
          expect(page).not_to have_content medicine_a.name
          expect(MedicineDosingTime.find(after_breakfast_medicine_a.id).discarded_at).not_to eq nil
          expect(MedicineDosingTime.find(before_dinner_medicine_a.id).discarded_at).not_to eq nil
        end
      end

      it '関連しないMedicineDosingTimeのデータは論理削除されないこと' do
        aggregate_failures do
          expect(page).not_to have_content medicine_a.name
          expect(MedicineDosingTime.find(after_breakfast_medicine_b.id).discarded_at).to eq nil
        end
      end
    end

    context '薬の削除をキャンセルしたとき' do
      let!(:medicine) { create(:medicine) }

      before do
        visit medicines_path
        dismiss_confirm { click_on '削除', id: "medicine-#{medicine.id}-delete_btn" }
      end

      it { expect(page).to have_content medicine.name }
    end

    context '削除した薬の名前で再び登録しようとしたとき' do
      let!(:medicine) { create(:medicine) }

      before do
        visit medicines_path
        accept_confirm { click_on '削除', id: "medicine-#{medicine.id}-delete_btn" }

        fill_in 'medicine[name]', with: medicine.name
        click_on '登録'
      end

      it { expect(page).to have_content medicine.name }
    end
  end
end
