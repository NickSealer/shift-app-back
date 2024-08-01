# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ShiftPolicy do
  let(:admin) { create(:user, role: 1) }
  let(:users) { create_list(:user, 3) }
  let(:service) { create(:service) }
  let(:shift) { create(:shift, service:, admin_id: admin.id) }
  let(:policy) { described_class.new(shift) }

  before do
    service.users << users
    service.users << admin
  end

  describe '#can_confirm?' do
    context 'when the number of confirmed availabilities equals the mandatory number of users' do
      before do
        allow(shift).to receive(:availabilities_confirmed).and_return(create_list(:availability, 3, confirmed: true))
      end

      it 'returns true' do
        expect(policy).to be_can_confirm
      end
    end

    context 'when the number of confirmed availabilities does not equal the mandatory number of users' do
      before do
        allow(shift).to receive(:availabilities_confirmed).and_return(create_list(:availability, 2, confirmed: false))
      end

      it 'returns false' do
        expect(policy).not_to be_can_confirm
      end
    end
  end

  describe '#total_hours_reached?' do
    let(:data) do
      {
        monday: { dates: [1, 2, 3] },
        tuesday: { dates: [] },
        wednesday: { dates: [] },
        thursday: { dates: [] },
        friday: { dates: [] },
        saturday: { dates: [] },
        sunday: { dates: [] }
      }
    end

    it 'returns true when total hours match the service total hours' do
      allow(service).to receive(:total_hours).and_return(3)
      expect(policy).to be_total_hours_reached(data)
    end

    it 'returns false when total hours do not match the service total hours' do
      allow(shift.service).to receive(:total_hours).and_return(20)
      expect(policy).not_to be_total_hours_reached(data)
    end
  end
end
