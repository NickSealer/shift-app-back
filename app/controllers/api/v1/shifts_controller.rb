# frozen_string_literal: true

module Api
  module V1
    class ShiftsController < ApplicationController
      before_action :authenticate_api_v1_user!
      before_action :service, only: %i[index show update destroy]
      before_action :shift, only: %i[show update destroy]

      def index
        shifts ||= current_api_v1_user.shifts.where(service_id: service.id).order(:week, :year).paginate(page: params[:page], per_page: 10)
        metadata = {
          current_page: shifts.current_page,
          per_page: shifts.per_page,
          next_page: shifts.next_page,
          previous_page: shifts.previous_page,
          total_pages: shifts.total_pages,
          total_entries: shifts.total_entries
        }

        render json: { shifts:, metadata: }, status: :ok
      end

      def show
        availabilities = shift.availabilities.as_json
        mandatory = service.users.user.size
        confirmed = shift.availabilities_confirmed.size

        render json: { shift:, availabilities:, mandatory:, confirmed: }, status: :ok
      end

      def create
        shift = ::ShiftFactory.create(current_api_v1_user, service, shift_params)
        return render json: { error: I18n.t('shift.constraints.uncofirmed_list') }, status: :bad_request if service.shifts.unconfirmed.size >= 10
        return render json: { error: shift.errors.full_messages }, status: :unprocessable_entity unless shift.save

        render json: { shift: }, status: :created
      end

      def update
        return render json: { error: I18n.t('shift.constraints.update') }, status: :bad_request if shift.confirmed

        success, message = ::Shifts::Confirm.execute(shift, shift_params)
        return render json: { error: message }, status: :unprocessable_entity unless success

        render json: { shift: message }, status: :ok
      end

      def destroy
        return render json: { error: I18n.t('shift.constraints.destroy') }, status: :bad_request if shift.confirmed

        shift.destroy
        render json: {}, status: :ok
      end

      private

      def shift_params
        params.require(:shift).permit(:confirmed, data: [json_body])
      end

      def json_body
        %w[monday tuesday wednesday thursday friday saturday sunday].map do |day|
          {
            day => {
              users: %i[user_id name availability],
              dates: %i[date hour user_id name]
            }
          }
        end
      end

      def service
        @service ||= current_api_v1_user.services.find_by(id: params[:service_id])
      end

      def shift
        @shift ||= current_api_v1_user.shifts.find_by(id: params[:id], service_id: service.id)
      end
    end
  end
end
