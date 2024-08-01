# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::WeeksController, type: :request do
  let(:user) { create(:user) }
  let(:auth_headers) { user.create_new_auth_token }

  describe 'GET /api/v1/weeks' do
    context 'with authenticated user' do
      it 'returns next 5 weeks' do
        get api_v1_weeks_url, headers: auth_headers

        expect(response).to have_http_status(:ok)
        expect(response.content_type).to include('application/json')
        json = JSON.parse(response.body)
        expect(json['weeks']).to be_a(Array)
        expect(json['weeks'].size).to eq(5)
      end
    end

    context 'with unauthenticated user' do
      it 'return 401 http status' do
        get api_v1_weeks_url
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
