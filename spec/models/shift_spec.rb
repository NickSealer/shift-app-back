# frozen_string_literal: true

# == Schema Information
# Schema version: 20240730204348
#
# Table name: shifts
#
#  id         :bigint           not null, primary key
#  confirmed  :boolean          default(FALSE)
#  data       :jsonb
#  week       :integer
#  year       :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  admin_id   :bigint           not null
#  service_id :bigint           not null
#
# Indexes
#
#  index_shifts_on_admin_id    (admin_id)
#  index_shifts_on_data        (data) USING gin
#  index_shifts_on_service_id  (service_id)
#
# Foreign Keys
#
#  fk_rails_...  (service_id => services.id)
#
require 'rails_helper'

RSpec.describe Shift, type: :model do
  let(:shift) { create(:shift) }

  describe 'AR associations' do
    it { is_expected.to belong_to(:service) }
    it { is_expected.to belong_to(:admin) }
  end

  describe 'AR indexes' do
    it { is_expected.to have_db_index(:admin_id) }
    it { is_expected.to have_db_index(:data) }
    it { is_expected.to have_db_index(:service_id) }
  end

  describe 'AR validations' do
    it { is_expected.to validate_numericality_of(:week).only_integer }
    it { is_expected.to validate_numericality_of(:year).only_integer }
  end

  describe 'Instance methods' do
    describe '#availabilities' do
      it 'returns availability relationship' do
        expect(shift.availabilities).to be_a(ActiveRecord::Relation)
      end
    end

    describe '#availabilities_confirmed' do
      it 'returns confirmed availability relationship' do
        expect(shift.availabilities_confirmed).to be_a(ActiveRecord::Relation)
      end
    end
  end
end
