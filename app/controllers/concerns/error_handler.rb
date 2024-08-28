module ErrorHandler
  extend ActiveSupport::Concern

  included do
    rescue_from ActiveRecord::RecordNotFound, with: :handle_not_found
    rescue_from ActiveRecord::RecordInvalid, with: :handle_invalid_record
    rescue_from ActiveRecord::RecordNotUnique, with: :handle_not_unique
  end

  private

  def handle_not_found(exception)
    render json: { error: "Resource not found" }, status: :not_found
  end

  def handle_invalid_record(exception)
    render json: { error: exception.record.errors.full_messages }, status: :unprocessable_entity
  end

  def handle_not_unique(exception)
    render json: { error: "Resource already exists" }, status: :conflict
  end
end
