require "test_helper"

class PayloadsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @payload = payloads(:one)
    @headers = { "X-Client-Token" => "test_token" }
  end

  test "should get index" do
    get payloads_url, as: :json
    assert_response :success
    assert_not_empty JSON.parse(@response.body)
  end

  test "should create payload" do
    assert_difference("Payload.count") do
      post api_v1_payloads_url, params: { payload: { content: "Test content" } }, headers: @headers, as: :json
    end

    assert_response :created
  end

  test "should show payload" do
    get payload_url(@payload.hash_id), as: :json
    assert_response :success
    assert_equal @payload.content, JSON.parse(@response.body)["content"]
  end

  test "should update payload" do
    patch api_v1_payload_url(@payload.hash_id),
          params: { payload: { content: "Updated content" } },
          headers: @headers,
          as: :json
    assert_response :success
    @payload.reload
    assert_equal "Updated content", @payload.content
  end

  test "should not create payload with invalid params" do
    assert_no_difference("Payload.count") do
      post payloads_url, params: { payload: { content: nil } }, as: :json
    end

    assert_response :unprocessable_entity
  end

  test "should return not found for non-existent payload" do
    get payload_url("non-existent-id"), as: :json
    assert_response :not_found
  end

  test "should handle update with invalid params" do
    patch payload_url(@payload.hash_id),
          params: { payload: { content: "a" * (Payload::MAX_CONTENT_SIZE + 1) } },
          as: :json
    assert_response :unprocessable_entity
  end
end
