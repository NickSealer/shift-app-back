# frozen_string_literal: true

class ShiftPolicy
  attr_reader :shift

  def initialize(shift)
    @shift = shift
  end

  def can_confirm?
    mandatory = shift.service.users.user.size
    confirmed = shift.availabilities_confirmed.size

    confirmed == mandatory
  end

  def total_hours_reached?(data)
    days_of_week = %i[monday tuesday wednesday thursday friday saturday sunday]
    total = days_of_week.sum { |day| data[day][:dates].size }
    shift.service.total_hours == total
  end
end
