require 'rails_helper'

RSpec.describe 'Notes', type: :request do
  describe 'GET /index' do
    context 'サインインしていない場合' do
      it 'リクエストが失敗すること' do
        get '/'
        expect(response).to have_http_status(302)
      end
    end

    context 'サインインしている場合' do
      it 'リクエストが成功すること' do
        sign_in build(:user)
        get '/'
        expect(response).to have_http_status(200)
      end
    end
  end
end
