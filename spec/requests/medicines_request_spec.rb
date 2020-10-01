require 'rails_helper'

RSpec.describe 'Medicines', type: :request do
  describe 'GET /index' do
    it 'returns http success' do
      get '/medicines/index'
      expect(response).to have_http_status(:success)
    end
  end
end
