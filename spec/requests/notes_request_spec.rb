require 'rails_helper'

RSpec.describe 'Notes', type: :request do
  describe 'GET /index' do
    it 'returns http success' do
      get '/'
      expect(response).to have_http_status(302)
    end
  end
end
