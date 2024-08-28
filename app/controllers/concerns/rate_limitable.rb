module RateLimitable
  extend ActiveSupport::Concern

  included do
    before_action :check_rate_limit
  end

  private

  def check_rate_limit
    limit = Rails.configuration.tinyapi.rate_limits[action_name.to_sym] || 1000 # Default to 1000 if not set
    key = "rate_limit:#{request.headers["X-Client-Token"]}:#{controller_name}:#{action_name}"
    count = Rails.cache.increment(key, 1, expires_in: 1.hour)

    if count > limit
      render json: { error: "Rate limit exceeded" }, status: :too_many_requests
    end
  rescue Redis::CannotConnectError => e
    Rails.logger.error "Redis connection error: #{e.message}"
    # Allow the request to proceed if Redis is unavailable
  end
end
