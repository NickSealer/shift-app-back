# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::AvailabilitiesController, type: :request do
  let(:user) { create(:user) }
  let(:auth_headers) { user.create_new_auth_token }
  let!(:service) { create(:service) }
  let(:availability) { create(:availability, user:, service:) }
  let(:availability_params) { attributes_for(:availability) }

  context 'with authenticated user' do
    before { service.users.push(user) }

    describe 'GET /api/v1/services/:service_id/availabilities' do
      it 'returns availability paginated list' do
        get api_v1_service_availabilities_url(service_id: service.id), headers: auth_headers

        expect(response).to have_http_status(:ok)
        expect(response.content_type).to include('application/json')
        json = JSON.parse(response.body)
        expect(json['availabilities']).to be_a(Array)
        expect(json['metadata']['current_page']).to eq(1)
        expect(json['metadata']['per_page']).to eq(10)
      end
    end

    describe 'POST /api/v1/services/:service_id/availabilities' do
      context 'when success response' do
        it 'creates the availability' do
          expect do
            post api_v1_service_availabilities_url(service_id: service.id), params: { availability: availability_params }, headers: auth_headers
          end.to change(Availability, :count).by(1)
          expect(response).to have_http_status(:created)
          expect(response.content_type).to include('application/json')
        end
      end

      context 'when fail response' do
        it 'returns 422 http status' do
          expect do
            post api_v1_service_availabilities_url(service_id: service.id), params: { availability: { from: 'bad data' } }, headers: auth_headers
          end.not_to change(Availability, :count)
          expect(response).to have_http_status(:unprocessable_entity)
          expect(response.content_type).to include('application/json')
        end
      end
    end

    describe 'PUT /api/v1/services/:service_id/availabilities/:id' do
      context 'when success response' do
        it 'updates the availability' do
          put api_v1_service_availability_url(service_id: service.id, id: availability.id), params: { availability: availability_params }, headers: auth_headers

          expect(response).to have_http_status(:ok)
          expect(response.content_type).to include('application/json')
          expect(JSON.parse(response.body)['availability']['id']).to eq(availability.id)
        end
      end

      context 'when fail response' do
        before do
          service = instance_double(Availabilities::Update)
          allow(Availabilities::Update).to receive(:new).and_return(service)
          allow(service).to receive(:execute).and_return(false)
        end

        it 'returns 422 http status' do
          put api_v1_service_availability_url(service_id: service.id, id: availability.id), params: { availability: availability_params }, headers: auth_headers

          expect(response).to have_http_status(:unprocessable_entity)
          expect(response.content_type).to include('application/json')
        end
      end
    end
  end

  context 'with unauthenticated user' do
    it 'return 401 http status' do
      get api_v1_service_availabilities_url(service.id)
      expect(response).to have_http_status(:unauthorized)
    end
  end
end
