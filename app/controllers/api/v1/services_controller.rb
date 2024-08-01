# frozen_string_literal: true

module Api
  module V1
    class ServicesController < ApplicationController
      before_action :authenticate_api_v1_user!

      def index
        services ||= current_api_v1_user.services.paginate(page: params[:page], per_page: 10)
        metadata = {
          current_page: services.current_page,
          per_page: services.per_page,
          next_page: services.next_page,
          previous_page: services.previous_page,
          total_pages: services.total_pages,
          total_entries: services.total_entries
        }

        render json: { services:, metadata: }, status: :ok
      end

      def show
        service = current_api_v1_user.services.find_by(id: params[:id])

        render json: { service: }, status: :ok
      end
    end
  end
end
