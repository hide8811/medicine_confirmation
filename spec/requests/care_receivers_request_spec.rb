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

  describe 'POST /create' do
    it 'returns http success' do
      post '/care_receivers', params: { care_receiver: attributes_for(:care_receiver) }
      expect(response).to have_http_status(302)
    end
  end

  describe 'GET /show' do
    it 'returns http success' do
      care_receiver = create(:care_receiver)
      get "/care_receivers/#{care_receiver.id}", params: { care_receiver: attributes_for(:care_receiver) }
      expect(response).to have_http_status(:success)
    end
  end
end
