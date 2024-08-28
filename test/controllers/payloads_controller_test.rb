require "test_helper"

class PayloadsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @payload = payloads(:one)
  end

  test "should get index" do
    get payloads_url, as: :json
    assert_response :success
  end

  test "should create payload" do
    assert_difference("Payload.count") do
      post payloads_url, params: { payload: { content: @payload.content, mime_type: @payload.mime_type } }, as: :json
    end

    assert_response :created
  end

  test "should show payload" do
    get payload_url(@payload.hash_id), as: :json
    assert_response :success
  end

  test "should update payload" do
    patch payload_url(@payload.hash_id),
          params: { payload: { content: @payload.content, mime_type: @payload.mime_type } },
          as: :json
    assert_response :success
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
end
