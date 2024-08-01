# frozen_string_literal: true

# == Schema Information
# Schema version: 20240728153706
#
# Table name: availabilities
#
#  id         :bigint           not null, primary key
#  confirmed  :boolean          default(FALSE)
#  from       :date
#  to         :date
#  week       :integer
#  year       :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  service_id :bigint           not null
#  user_id    :bigint           not null
#
# Indexes
#
#  index_availabilities_on_service_id  (service_id)
#  index_availabilities_on_user_id     (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (service_id => services.id)
#  fk_rails_...  (user_id => users.id)
#
require 'rails_helper'

RSpec.describe Availability, type: :model do
  let(:availability) { create(:availability) }
  let(:shift) { create(:shift, week: availability.week, year: availability.year, service_id: availability.service_id) }

  describe 'AR associations' do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to belong_to(:service) }
    it { is_expected.to have_many(:days) }
  end

  describe 'AR indexes' do
    it { is_expected.to have_db_index(:service_id) }
    it { is_expected.to have_db_index(:user_id) }
  end

  describe 'AR validations' do
    it { is_expected.to validate_presence_of(:from) }
    it { is_expected.to validate_presence_of(:week) }
    it { is_expected.to validate_presence_of(:year) }
    it { is_expected.to validate_numericality_of(:week).only_integer }
    it { is_expected.to validate_numericality_of(:year).only_integer }
  end

  describe 'Instance methods' do
    describe '#shift' do
      it 'returns shift associated' do
        shift
        expect(availability.shift).to be_a(Shift)
      end
    end
  end
end
