require "test_helper"

class PayloadsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @payload = payloads(:one)
  end

  test "should get index" do
    get payloads_url, as: :json
    assert_response :success
    assert_not_empty JSON.parse(@response.body)
  end

  test "should create payload" do
    assert_difference("Payload.count") do
      post payloads_url, params: { payload: { content: "New content", mime_type: "text/plain" } }, as: :json
    end

    assert_response :created
    assert_not_nil JSON.parse(@response.body)["hash_id"]
  end

  test "should show payload" do
    get payload_url(@payload.hash_id), as: :json
    assert_response :success
    assert_equal @payload.content, JSON.parse(@response.body)["content"]
  end

  test "should update payload" do
    patch payload_url(@payload.hash_id),
          params: { payload: { content: "Updated content" } },
          as: :json
    assert_response :success
    assert_equal "Updated content", Payload.find_by(hash_id: @payload.hash_id).content
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
