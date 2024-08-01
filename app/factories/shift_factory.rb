# frozen_string_literal: true

class ShiftFactory < ApplicationFactory
  attr_reader :user, :service, :params

  def initialize(user, service, params)
    super
    @user = user
    @service = service
    @params = params
  end

  def create
    shift = user.shifts.build(params)
    shift.service_id = service.id
    shift.year = Time.zone.now.year
    shift.week = week_number(shift)

    shift
  end

  private

  # Method to ensure next week in the current year per service

  def week_number(shift)
    return Time.zone.now.to_date.cweek if Shift.none?

    last_shift = service.shifts.last
    last_shift&.year == shift&.year ? (last_shift&.week&.+ 1) : Time.zone.now.to_date.cweek
  end
end
