require 'rails_helper'

RSpec.describe 'Medicines', type: :system do
  before do
    user = create(:user)
    login_as(user, scope: :user)
  end

  describe 'サイドボタン' do
    context 'ホーム画面から遷移してきた場合' do
      before do
        visit root_path
        click_on '薬'
      end

      it { expect(page).to have_link 'ホーム' }

      it { expect(page).not_to have_link '戻る' }

      context '遷移後すぐホームボタンを押したとき' do
        before { click_on 'ホーム' }
        it { expect(current_path).to eq root_path }
      end

      context '薬を登録後、ホームボタンを押したとき' do
        let(:medicine_name) { Faker::Lorem.word }

        before do
          fill_in 'medicine[name]', with: medicine_name
          click_on '新規登録'
          find('.medicines_list__item', text: medicine_name)
          click_on 'ホーム'
        end

        it { expect(current_path).to eq root_path }
      end
    end

    context '服薬編集画面から遷移してきた場合' do
      let(:care_receiver) { create(:care_receiver) }

      before do
        visit care_receiver_dosing_times_path(care_receiver)
        click_on '薬 新規登録'
      end

      it { expect(page).to have_link '戻る' }

      it { expect(page).not_to have_link 'ホーム' }

      context '遷移後すぐ戻るボタンを押したとき' do
        before { click_on '戻る' }
        it { expect(current_path).to eq care_receiver_dosing_times_path(care_receiver) }
      end

      context '薬を登録後、戻るボタンを押したとき' do
        let(:medicine_name) { Faker::Lorem.word }

        before do
          fill_in 'medicine[name]', with: medicine_name
          click_on '新規登録'
          find('.medicines_list__item', text: medicine_name)
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
end
