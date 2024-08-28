class PayloadsController < ApplicationController
  before_action :set_payload, only: [ :show, :update ]

  def index
    @payloads = Payload.all
    render json: @payloads
  end

  def show
    render json: @payload
  end

  def create
    @payload = Payload.new(payload_params)
    @payload.hash_id = SecureRandom.hex(10) # Generate a unique hash_id

    if @payload.save
      render json: @payload, status: :created, location: @payload
    else
      render json: @payload.errors, status: :unprocessable_entity
    end
  end

  def update
    if @payload.update(payload_params)
      render json: @payload
    else
      render json: @payload.errors, status: :unprocessable_entity
    end
  end

  private

  def set_payload
    @payload = Payload.find_by!(hash_id: params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: "Payload not found" }, status: :not_found
  end

  def payload_params
    params.require(:payload).permit(:content, :mime_type)
  end
end
