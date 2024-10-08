require "simplecov"
require "simplecov-cobertura"

SimpleCov.start "rails" do
  enable_coverage :branch
  formatter SimpleCov::Formatter::CoberturaFormatter
end

ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"
require "minitest/autorun"

class ActiveSupport::TestCase
  # Run tests in parallel with specified workers
  parallelize(workers: :number_of_processors)

  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here...
end

# Use FakeRedis for testing if available, otherwise use real Redis
begin
  require "fakeredis/minitest"
  puts "Using FakeRedis for testing"
rescue LoadError
  puts "FakeRedis not available, using real Redis for testing"
  require "redis"
  REDIS = Redis.new(url: ENV["REDIS_URL"] || "redis://localhost:6379/1")
end
