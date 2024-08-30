module RateLimitable
  extend ActiveSupport::Concern

  included do
    before_action :check_rate_limit
  end

  private

  def check_rate_limit
    current_count = REDIS.get(rate_limit_key).to_i

    REDIS.multi do |pipeline|
      pipeline.incr(rate_limit_key)
      pipeline.expire(rate_limit_key, 1.hour.to_i)
    end

    if current_count >= rate_limit
      render json: { error: "Rate limit exceeded. Try again later." }, status: :too_many_requests
    end
  end

  def rate_limit_key
    "#{controller_name}:#{action_name}:#{request.ip}"
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
