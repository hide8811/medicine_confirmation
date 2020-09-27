require 'rails_helper'

RSpec.describe 'CareReceivers', type: :request do
  before do
    user = create(:user)
    login_as(user, scope: :user)
  end

  describe 'GET /new' do
    it 'returns http success' do
      get '/care_receivers/new'
      expect(response).to have_http_status(:success)
    end
  end

  describe 'GET /create' do
    it 'returns http success' do
      get '/care_receivers/create'
      expect(response).to have_http_status(:success)
    end
  end

  describe 'GET /show' do
    it 'returns http success' do
      get '/care_receivers/show'
      expect(response).to have_http_status(:success)
    end
  end
end
