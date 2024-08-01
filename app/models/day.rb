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
class Day < ApplicationRecord
  before_save :set_date
  belongs_to :availability

  DAYS = { monday: 1, tuesday: 2, wednesday: 3, thursday: 4, friday: 5, saturday: 6, sunday: 0 }.with_indifferent_access.freeze

  validates_presence_of :day_name, :time
  validates_inclusion_of :day_name, { in: Day::DAYS.keys }

  private

  def set_date
    week = availability.from..availability.to
    self.date = week.find { |day| day.wday == Day::DAYS[day_name] }.to_date
  end
end
