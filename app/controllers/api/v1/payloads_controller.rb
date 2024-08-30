module Api
  module V1
    class PayloadsController < ApplicationController
      include RateLimitable

      before_action :set_client_token

      def create
        @payload = PayloadService.create(payload_params, @client_token)
        render json: @payload, status: :created
      rescue ActiveRecord::RecordInvalid => e
        render_error(e.message, :unprocessable_entity)
      end

      def update
        @payload = PayloadService.update(params[:hash_id], payload_params, @client_token)
        render json: @payload
      rescue ActiveRecord::RecordNotFound
        render_error("Payload not found", :not_found)
      rescue ActiveRecord::RecordInvalid => e
        render_error(e.message, :unprocessable_entity)
      end

      def show
        @payload = PayloadService.find(params[:hash_id], @client_token)
        render json: @payload
      rescue ActiveRecord::RecordNotFound
        render_error("Payload not found", :not_found)
      end

      private

      def payload_params
        params.require(:payload).permit(:content, :expiry_time)
      end

      def set_client_token
        @client_token = request.headers["X-Client-Token"]
        render_error("Missing client token", :unauthorized) unless @client_token
      end

      def render_error(message, status)
        render json: { errors: [ message ] }, status: status
      end
    end
  end
end
