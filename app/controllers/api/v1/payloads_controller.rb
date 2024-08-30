module Api
  module V1
    class PayloadsController < ApplicationController
      include RateLimitable

      before_action :set_client_token

      def create
        result = PayloadService.create(payload_params.merge(client_token: @client_token), @client_token)
        if result.success?
          render json: result.payload, status: :created
        else
          render json: { errors: result.errors }, status: :unprocessable_entity
        end
      end

      def update
        result = PayloadService.update(params[:hash_id], payload_params, @client_token)
        if result.success?
          render json: result.payload
        else
          render json: { errors: result.errors }, status: :unprocessable_entity
        end
      end

      def show
        result = PayloadService.find(params[:hash_id], @client_token)
        if result
          render json: result
        else
          render json: { error: "Payload not found" }, status: :not_found
        end
      end

      private

      def payload_params
        params.require(:payload).permit(:content, :expiry_time)
      end

      def set_client_token
        @client_token = request.headers["X-Client-Token"]
        render json: { error: "Missing client token" }, status: :unauthorized unless @client_token
      end
    end
  end
end
