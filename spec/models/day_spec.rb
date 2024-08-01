# frozen_string_literal: true

# == Schema Information
# Schema version: 20240728153706
#
# Table name: days
#
#  id              :bigint           not null, primary key
#  available       :boolean          default(FALSE)
#  date            :date
#  day_name        :string
#  time            :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  availability_id :bigint           not null
#
# Indexes
#
#  index_days_on_availability_id  (availability_id)
#
# Foreign Keys
#
#  fk_rails_...  (availability_id => availabilities.id)
#
require 'rails_helper'

RSpec.describe Day, type: :model do
  describe 'AR associations' do
    it { is_expected.to belong_to(:availability) }
  end

  describe 'AR indexes' do
    it { is_expected.to have_db_index(:availability_id) }
  end

  describe 'AR validations' do
    it { is_expected.to validate_presence_of(:day_name) }
    it { is_expected.to validate_presence_of(:time) }
    it { is_expected.to validate_inclusion_of(:day_name).in_array(Day::DAYS.keys) }
  end
end
