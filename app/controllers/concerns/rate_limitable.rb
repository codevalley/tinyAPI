module RateLimitable
  extend ActiveSupport::Concern

  included do
    before_action :check_rate_limit
  end

  private

  def check_rate_limit
    key = "rate_limit:#{request.ip}:#{controller_name}:#{action_name}"
    count = REDIS.get(key).to_i

    if count >= rate_limit
      render json: { error: "Rate limit exceeded" }, status: :too_many_requests
    else
      REDIS.multi do
        REDIS.incr(key)
        REDIS.expire(key, 1.hour.to_i)
      end
    end
  end

  def rate_limit
    case action_name.to_sym
    when :create
      100
    when :update
      200
    when :show
      1000
    else
      50 # Default rate limit
    end
  end
end
