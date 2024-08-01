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
FactoryBot.define do
  factory :availability do
    week { Date.today.cweek }
    year { Date.today.year }
    from { Date.today.beginning_of_week }
    to { Date.today.end_of_week }
    association :user
    association :service
  end
end
