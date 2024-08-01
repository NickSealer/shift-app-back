# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::ServicesController, type: :request do
  let(:user) { create(:user) }
  let(:auth_headers) { user.create_new_auth_token }
  let(:service) { create(:service) }

  context 'with authenticated user' do
    before { service.users.push(user) }

    describe 'GET /api/v1/services' do
      it 'returns service paginated list' do
        get api_v1_services_url, headers: auth_headers

        expect(response).to have_http_status(:ok)
        expect(response.content_type).to include('application/json')
        json = JSON.parse(response.body)
        expect(json['services']).to be_a(Array)
        expect(json['metadata']['current_page']).to eq(1)
        expect(json['metadata']['per_page']).to eq(10)
      end
    end

    describe 'GET /api/v1/service/:id' do
      it 'returns the service' do
        get api_v1_service_url(user.services.first), headers: auth_headers

        expect(response).to have_http_status(:ok)
        expect(response.content_type).to include('application/json')
        expect(JSON.parse(response.body)['service']['id']).to eq(service.id)
      end
    end
  end

  context 'with unauthenticated user' do
    it 'returns 401 http status' do
      get api_v1_services_url
      expect(response).to have_http_status(:unauthorized)
    end
  end
end
