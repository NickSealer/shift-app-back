# frozen_string_literal: true

module Api
  module V1
    class WeeksController < ApplicationController
      before_action :authenticate_api_v1_user!

      def weeks
        render json: { weeks: week_options }, status: :ok
      end

      private

      def week_options
        weeks = []
        today = Time.zone.now.to_date

        5.times do |w|
          date = (today + w.week)
          weeks << [date.beginning_of_week, "(Semana #{date.cweek}) - #{date.beginning_of_week} - #{date.end_of_week}"]
        end

        weeks
      end
    end
  end
end
