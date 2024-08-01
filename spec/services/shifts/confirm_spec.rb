# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Shifts::Confirm, type: :service do
  let(:shift) { create(:shift) }
  let(:params) do
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

  let(:service) { described_class.new(shift, params) }
  let(:policy) { instance_double(ShiftPolicy) }

  describe '#execute' do
    context 'when shift meets the policies' do
      before do
        allow(ShiftPolicy).to receive(:new).and_return(policy)
        allow(policy).to receive_messages(can_confirm?: true, total_hours_reached?: true)
      end

      it 'updates the shift' do
        result, updated_shift = service.execute

        expect(result).to be_truthy
        expect(updated_shift).to eq(shift)
        expect(shift.reload.confirmed).to be_truthy
      end
    end

    context 'when shift cannot be confirmed because confirm policy' do
      before do
        allow(ShiftPolicy).to receive(:new).and_return(policy)
        allow(policy).to receive(:can_confirm?).and_return(false)
      end

      it 'returns false' do
        result, message = service.execute

        expect(result).to be_falsey
        expect(message).to eq(I18n.t('shift.services.policies.confirm'))
      end
    end

    context 'when shift cannot be confirmed because total hours policy' do
      before do
        allow(ShiftPolicy).to receive(:new).and_return(policy)
        allow(policy).to receive_messages(can_confirm?: true, total_hours_reached?: false)
      end

      it 'returns false' do
        result, message = service.execute

        expect(result).to be_falsey
        expect(message).to eq(I18n.t('shift.services.policies.total_hours'))
      end
    end

    context 'when there is an internal server error' do
      it 'returns false' do
        result, message = service.execute

        expect(result).to be_falsey
        expect(message).to eq(I18n.t('shift.services.errors.error'))
      end
    end
  end
end
