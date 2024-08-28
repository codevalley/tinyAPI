module Api
  module V1
    class PayloadsController < ApplicationController
      include RateLimitable

      def add
        payload = Payload.new(payload_params)
        payload.hash_id = SecureRandom.hex(10)

        if payload.save
          render json: payload_response(payload), status: :created
        else
          render json: { errors: payload.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def edit
        payload = Payload.find_by!(hash_id: params[:hash_id])

        if payload.update(payload_params)
          render json: payload_response(payload)
        else
          render json: { errors: payload.errors.full_messages }, status: :unprocessable_entity
        end
      rescue ActiveRecord::RecordNotFound
        render json: { error: 'Payload not found' }, status: :not_found
      end

      def get
        payload = Payload.find_by!(hash_id: params[:hash_id])
        payload.update(viewed_at: Time.current)

        render json: payload_response(payload)
      rescue ActiveRecord::RecordNotFound
        render json: { error: 'Payload not found' }, status: :not_found
      end

      private

      def payload_params
        params.require(:payload).permit(:content, :mime_type, :expiry_time)
      end

      def payload_response(payload)
        {
          hash_id: payload.hash_id,
          content: payload.content,
          mime_type: payload.mime_type,
          created_at: payload.created_at,
          updated_at: payload.updated_at,
          viewed_at: payload.viewed_at,
          expiry_time: payload.expiry_time
        }
      end
    end
  end
end