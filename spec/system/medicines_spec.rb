require 'rails_helper'

RSpec.describe 'Medicines', type: :system do
  before do
    user = create(:user)
    login_as(user, scope: :user)
  end

  describe 'サイドボタン' do
    before do
      visit root_path
      click_on '薬一覧'
    end

    context '戻るボタンを押した時' do
      it '元の画面に戻ること' do
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
        create(:medicine, image: nil)
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
        create(:medicine, url: 'NULL')
        visit medicines_path
        expect(page).to have_css '.medicines_list__item--no_url'
      end
    end
  end
end
