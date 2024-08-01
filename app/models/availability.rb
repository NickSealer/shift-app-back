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
class Availability < ApplicationRecord
  belongs_to :user
  belongs_to :service
  has_many :days, dependent: :destroy

  validates_presence_of :from, :week, :year
  validates :week, numericality: { only_integer: true }
  validates :year, numericality: { only_integer: true }

  validate :week_existence

  accepts_nested_attributes_for :days, allow_destroy: true

  def as_json
    {
      id:,
      week:,
      year:,
      from:,
      to:,
      confirmed:,
      user_id:,
      service_id:,
      user_name: user.full_name,
      days: JSON.parse(days.to_json)
    }
  end

  def shift
    Shift.find_by(week:, year:, service_id:)
  end

  private

  def week_existence
    errors.add(:week, I18n.t('availability.errors.week')) if Availability.find_by(week:, year:, service_id:, user_id:)
  end
end
