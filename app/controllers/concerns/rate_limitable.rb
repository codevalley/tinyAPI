module RateLimitable
  extend ActiveSupport::Concern

  included do
    before_action :check_rate_limit
  end

  private

  def check_rate_limit
    return if Rails.env.test? && ENV["DISABLE_RATE_LIMIT"]
    return unless REDIS # Skip rate limiting if Redis is not available

    client_token = request.headers["X-Client-Token"]
    action = "#{controller_name}##{action_name}"
    key = "rate_limit:#{client_token}:#{action}"
    limit = rate_limit_for_action(action)

    count = REDIS.get(key).to_i

    if count >= limit
      render json: { error: "Rate limit exceeded" }, status: :too_many_requests
    else
      REDIS.multi do
        REDIS.incr(key)
        REDIS.expire(key, 1.hour.to_i)
      end
    end
  rescue Redis::BaseError => e
    Rails.logger.error "Redis error in rate limiting: #{e.message}"
    # Optionally, you can choose to skip rate limiting on Redis errors
    # or implement a fallback strategy
  end

  def rate_limit_for_action(action)
    case action
    when "payloads#create"
      100
    when "payloads#update"
      200
    when "payloads#show"
      1000
    else
      50 # Default limit
    end
  end
end
