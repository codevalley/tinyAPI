require "redis"

unless defined?(REDIS)
  redis_url = ENV["REDIS_URL"] || "redis://localhost:6379/0"

  REDIS = Redis.new(url: redis_url)

  # Add error handling
  begin
    REDIS.ping
  rescue Redis::CannotConnectError => e
    Rails.logger.error "Failed to connect to Redis: #{e.message}"
    REDIS = nil
  end
end
