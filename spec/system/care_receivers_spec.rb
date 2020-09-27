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
  end
end
