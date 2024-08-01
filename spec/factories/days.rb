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
FactoryBot.define do
  factory :day do
    date { '2024-07-28' }
    day_name { 'MyString' }
    time { 'MyString' }
    available { false }
    availability { nil }
  end
end
