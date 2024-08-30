require "test_helper"

class RateLimitableTest < ActionDispatch::IntegrationTest
  include ActiveSupport::Testing::TimeHelpers

  setup do
    @client_token = "test_token"
    @limit = 100 # Assuming the limit for create action is 100
  end

  test "blocks requests exceeding rate limit" do
    @limit.times do
      post api_v1_payloads_path, params: { payload: { content: "Test" } }, headers: { "X-Client-Token": @client_token }
      assert_response :success
    end

    # This request should exceed the rate limit
    post api_v1_payloads_path, params: { payload: { content: "Test" } }, headers: { "X-Client-Token": @client_token }
    assert_response :too_many_requests
    assert_equal({ "error" => "Rate limit exceeded" }, JSON.parse(response.body))
  end

  test "resets rate limit after an hour" do
    @limit.times do
      post api_v1_payloads_path, params: { payload: { content: "Test" } }, headers: { "X-Client-Token": @client_token }
      assert_response :success
    end

    # This request should exceed the rate limit
    post api_v1_payloads_path, params: { payload: { content: "Test" } }, headers: { "X-Client-Token": @client_token }
    assert_response :too_many_requests

    # Travel 1 hour into the future
    travel 1.hour do
      post api_v1_payloads_path, params: { payload: { content: "Test" } }, headers: { "X-Client-Token": @client_token }
      assert_response :success
    end
  end
end
