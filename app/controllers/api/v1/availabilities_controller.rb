# frozen_string_literal: true

module Api
  module V1
    class AvailabilitiesController < ApplicationController
      before_action :authenticate_api_v1_user!
      before_action :service, only: %i[index update]

      def index
        availabilities ||= current_api_v1_user.availabilities.where(service_id: service.id).order(:week, :year).paginate(page: params[:page], per_page: 10)
        metadata = {
          current_page: availabilities.current_page,
          per_page: availabilities.per_page,
          next_page: availabilities.next_page,
          previous_page: availabilities.previous_page,
          total_pages: availabilities.total_pages,
          total_entries: availabilities.total_entries
        }
        render json: { availabilities: availabilities.map(&:as_json), metadata: }, status: :ok
      end

      def create
        availability = ::AvailabilityFactory.create(current_api_v1_user, service, availability_params)
        return render json: { error: availability.errors.full_messages }, status: :unprocessable_entity unless availability.save

        render json: { availability: availability.as_json }, status: :created
      end

      def update
        availability = current_api_v1_user.availabilities.find_by(id: params[:id], service_id: service.id)
        availability_updated = ::Availabilities::Update.execute(availability, availability_params)
        return render json: { error: I18n.t('availability.errors.update') }, status: :unprocessable_entity unless availability_updated

        render json: { availability: availability_updated.as_json }, status: :ok
      end

      private

      def availability_params
        params.require(:availability).permit(
          :from, :confirmed,
          days_attributes: %i[date day_name time available]
        )
      end

      def service
        @service ||= current_api_v1_user.services.find_by(id: params[:service_id])
      end
    end
  end
end
