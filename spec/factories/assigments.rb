# frozen_string_literal: true

# == Schema Information
# Schema version: 20240727191725
#
# Table name: assigments
#
#  id         :bigint           not null, primary key
#  active     :boolean          default(TRUE)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  service_id :bigint
#  user_id    :bigint
#
# Indexes
#
#  index_assigments_on_service_id  (service_id)
#  index_assigments_on_user_id     (user_id)
#
FactoryBot.define do
  factory :assigment do
    association :user
    association :service
  end
end
