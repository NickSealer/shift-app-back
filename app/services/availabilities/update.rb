# frozen_string_literal: true

module Availabilities
  class Update < ApplicationService
    attr_reader :availability, :params

    def initialize(availability, params)
      super
      @availability = availability
      @params = params
    end

    def execute
      update_availability
    end

    private

    def update_availability
      old_day_ids = availability.days.ids
      if availability.days.create(params[:days_attributes])
        Day.delete(old_day_ids)
        availability.update_attribute(:confirmed, true) if params[:confirmed]
      end

      availability
    rescue StandardError => e
      Rails.logger.error(e)
      false
    end
  end
end
