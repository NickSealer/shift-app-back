# frozen_string_literal: true

class AvailabilityFactory < ApplicationFactory
  attr_reader :user, :service, :params

  def initialize(user, service, params)
    super
    @user = user
    @service = service
    @params = params
  end

  def create
    availability = user.availabilities.build(params)
    availability.service_id = service.id
    from_date = safe_to_date(params[:from])

    if from_date.present?
      availability.week = from_date.cweek
      availability.year = from_date.year
      availability.to = from_date.end_of_week
    end

    availability
  end

  private

  def safe_to_date(str)
    Date.parse(str)
  rescue StandardError
    nil
  end
end
