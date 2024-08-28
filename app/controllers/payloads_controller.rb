class PayloadsController < ApplicationController
  include ErrorHandler

  # ... existing code ...

  def add
    @payload = Payload.new(payload_params)
    if @payload.save
      render json: { id: @payload.id }, status: :created
    else
      render json: { error: @payload.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def edit
    @payload = Payload.find_by!(id: params[:id])
    if @payload.update(payload_params)
      head :no_content
    else
      render json: { error: @payload.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def get
    @payload = Rails.cache.fetch("payload_#{params[:id]}", expires_in: 1.hour) do
      Payload.find_by!(id: params[:id])
    end
    render json: { data: @payload.data }
  end

  private

  def payload_params
    params.require(:payload).permit(:data, :expiry)
  end
end
