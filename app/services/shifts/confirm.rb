# frozen_string_literal: true

module Shifts
  class Confirm < ApplicationService
    attr_reader :shift, :params

    def initialize(shift, params)
      super
      @shift = shift
      @params = params
    end

    def execute
      return [false, I18n.t('shift.services.policies.confirm')] unless shift_policy.can_confirm?
      return [false, I18n.t('shift.services.policies.total_hours')] unless shift_policy.total_hours_reached?(params[:data])

      [shift.update(params), shift]
    rescue StandardError => e
      Rails.logger.error(e)
      [false, I18n.t('shift.services.errors.error')]
    end

    private

    def shift_policy
      @shift_policy ||= ShiftPolicy.new(shift)
    end
  end
end
