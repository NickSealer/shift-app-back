# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::ShiftsController, type: :request do
  let(:user) { create(:user) }
  let(:auth_headers) { user.create_new_auth_token }
  let!(:service) { create(:service) }
  let(:availability) { create(:availability, user:, service:) }
  let(:shift) { create(:shift, admin_id: user.id, service_id: service.id) }
  let(:shift_params) do
    {
      confirmed: true,
      data: {
        monday: {
          users: [{ user_id: 1, name: 'User name 1', availability: 1 }],
          dates: [{ hour: '08:00-09:00', date: '2024-08-05', user_id: 1, user_name: 'User name 1' }]
        },
        tuesday: {
          users: [{ user_id: 1, name: 'User name 2', availability: 1 }],
          dates: [{ hour: '09:00-10:00', date: '2024-08-06', user_id: 2, user_name: 'User name 2' }]
        }
      }
    }
  end

  context 'with authenticated user' do
    before { service.users.push(user) }

    describe 'GET /api/v1/services/:service_id/shifts' do
      it 'returns shift paginated list' do
        get api_v1_service_shifts_url(service_id: service.id), headers: auth_headers

        expect(response).to have_http_status(:ok)
        expect(response.content_type).to include('application/json')
        json = JSON.parse(response.body)
        expect(json['shifts']).to be_a(Array)
        expect(json['metadata']['current_page']).to eq(1)
        expect(json['metadata']['per_page']).to eq(10)
      end
    end

    describe 'GET /api/v1/services/:service_id/shifts/:id' do
      it 'return the shift' do
        get api_v1_service_shift_url(service_id: service.id, id: shift.id), headers: auth_headers

        expect(response).to have_http_status(:ok)
        expect(response.content_type).to include('application/json')
      end
    end

    describe 'POST /api/v1/services/:service_id/shifts' do
      context 'when success response' do
        it 'creates the shift' do
          expect do
            post api_v1_service_shifts_url(service_id: service.id), params: { shift: shift_params }, headers: auth_headers
          end.to change(Shift, :count).by(1)
          expect(response).to have_http_status(:created)
          expect(response.content_type).to include('application/json')
        end
      end

      context 'when fail response' do
        before do
          create_list(:shift, 10, admin_id: user.id, service_id: service.id)
        end

        it 'returns 400 http status' do
          expect do
            post api_v1_service_shifts_url(service_id: service.id), params: { shift: shift_params }, headers: auth_headers
          end.not_to change(Shift, :count)
          expect(response).to have_http_status(:bad_request)
          expect(response.content_type).to include('application/json')
        end
      end
    end

    describe 'PUT /api/v1/services/:service_id/shifts/:id' do
      context 'when success response' do
        before do
          service = instance_double(Shifts::Confirm)
          allow(Shifts::Confirm).to receive(:new).and_return(service)
          allow(service).to receive(:execute).and_return([true, shift])
        end

        it 'confirms the shift' do
          put api_v1_service_shift_url(service_id: service.id, id: shift.id), params: { shift: shift_params }, headers: auth_headers

          expect(response).to have_http_status(:ok)
          expect(response.content_type).to include('application/json')
          expect(JSON.parse(response.body)['shift']['id']).to eq(shift.id)
        end
      end

      context 'when fail response' do
        before do
          service = instance_double(Shifts::Confirm)
          allow(Shifts::Confirm).to receive(:new).and_return(service)
          allow(service).to receive(:execute).and_return(false)
        end

        it 'returns 422 http status' do
          put api_v1_service_shift_url(service_id: service.id, id: shift.id), params: { shift: shift_params }, headers: auth_headers

          expect(response).to have_http_status(:unprocessable_entity)
          expect(response.content_type).to include('application/json')
        end

        it 'returns 400 http status when shift is already confirmed' do
          shift.update(confirmed: true)
          put api_v1_service_shift_url(service_id: service.id, id: shift.id), params: { shift: shift_params }, headers: auth_headers

          expect(response).to have_http_status(:bad_request)
          expect(response.content_type).to include('application/json')
        end
      end
    end

    describe 'DELETE /api/v1/services/:service_id/shifts/:id' do
      context 'when success response' do
        it 'deletes the shift' do
          shift
          expect do
            delete api_v1_service_shift_url(service_id: service.id, id: shift.id), params: { shift: shift_params }, headers: auth_headers
          end.to change(Shift, :count).by(-1)
          expect(response).to have_http_status(:ok)
          expect(response.content_type).to include('application/json')
        end
      end

      context 'when fail response' do
        it 'returns 400 http status when shift is already confirmed' do
          shift.update(confirmed: true)
          expect do
            delete api_v1_service_shift_url(service_id: service.id, id: shift.id), params: { shift: shift_params }, headers: auth_headers
          end.not_to change(Shift, :count)
          expect(response).to have_http_status(:bad_request)
          expect(response.content_type).to include('application/json')
        end
      end
    end
  end

  context 'with unauthenticated user' do
    it 'return 401 http status' do
      get api_v1_service_shifts_url(service.id)
      expect(response).to have_http_status(:unauthorized)
    end
  end
end
