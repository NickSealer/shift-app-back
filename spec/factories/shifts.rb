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
FactoryBot.define do
  factory :shift do
    week { Date.today.cweek }
    year { Date.today.year }
    association :admin, factory: :user
    association :service
  end
end
