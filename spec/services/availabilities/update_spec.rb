# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Availabilities::Update, type: :service do
  let(:availability) { create(:availability) }
  let(:params) do
    {
      confirmed: true,
      days_attributes: [
        { date: Date.today, day_name: 'monday', time: '08:00-09:00', available: true },
        { date: Date.today, day_name: 'monday', time: '09:00-10:00', available: true }
      ]
    }
  end

  let(:service) { described_class.new(availability, params) }

  describe '#execute' do
    context 'whent success' do
      it 'creates days' do
        old_day_ids = availability.days.ids
        expect(Day.where(id: old_day_ids)).to be_empty

        expect do
          service.execute
        end.to change { availability.days.count }.from(0).to(2)
      end

      it 'confirms availability' do
        service.execute
        expect(availability.reload.confirmed).to be_truthy
      end
    end

    context 'when fails' do
      it 'returns false' do
        expect(described_class.execute(availability, nil)).to be_falsey
      end
    end
  end
end
