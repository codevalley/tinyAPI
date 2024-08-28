require "test_helper"

class RateLimitableTest < ActionDispatch::IntegrationTest
  class TestController < ApplicationController
    include RateLimitable

    def test_action
      render json: { message: "Success" }
    end
  end

  setup do
    Rails.application.routes.draw do
      get "test/rate_limit" => "rate_limitable_test/test#test_action"
    end
    Rails.configuration.tinyapi ||= OpenStruct.new
    Rails.configuration.tinyapi.rate_limits = { test_action: 2 }
    Rails.cache.clear
  end

  teardown do
    Rails.application.reload_routes!
    Rails.cache.clear
  end

  test "allows requests within rate limit" do
    2.times do
      get "/test/rate_limit", headers: { "X-Client-Token" => "test_token" }
      assert_response :success
    end
  end

  test "blocks requests exceeding rate limit" do
    3.times do |i|
      get "/test/rate_limit", headers: { "X-Client-Token" => "test_token" }
      if i < 2
        assert_response :success
      else
        assert_response :too_many_requests
        assert_equal({ "error" => "Rate limit exceeded" }, JSON.parse(@response.body))
      end
    end
  end

  test "handles Redis connection error" do
    original_increment = Rails.cache.method(:increment)
    Rails.cache.define_singleton_method(:increment) do |*args|
      raise Redis::CannotConnectError.new("Connection refused")
    end

    get "/test/rate_limit", headers: { "X-Client-Token" => "test_token" }
    assert_response :success

    Rails.cache.singleton_class.send(:remove_method, :increment)
    Rails.cache.define_singleton_method(:increment, original_increment)
  end
end
