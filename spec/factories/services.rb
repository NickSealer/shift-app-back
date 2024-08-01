# frozen_string_literal: true

# == Schema Information
# Schema version: 20240728153706
#
# Table name: services
#
#  id          :bigint           not null, primary key
#  friday      :string           default([]), is an Array
#  monday      :string           default([]), is an Array
#  name        :string
#  saturday    :string           default([]), is an Array
#  sunday      :string           default([]), is an Array
#  thursday    :string           default([]), is an Array
#  total_hours :integer          default(0)
#  tuesday     :string           default([]), is an Array
#  wednesday   :string           default([]), is an Array
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# Indexes
#
#  index_services_on_friday     (friday) USING gin
#  index_services_on_monday     (monday) USING gin
#  index_services_on_saturday   (saturday) USING gin
#  index_services_on_sunday     (sunday) USING gin
#  index_services_on_thursday   (thursday) USING gin
#  index_services_on_tuesday    (tuesday) USING gin
#  index_services_on_wednesday  (wednesday) USING gin
#
FactoryBot.define do
  factory :service do
    name { 'Service name' }
  end

  trait :with_hours do
    total_hours { 20 }
  end
end
