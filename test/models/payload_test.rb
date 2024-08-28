require "test_helper"

class PayloadTest < ActiveSupport::TestCase
  test "should not save payload without content" do
    payload = Payload.new
    assert_not payload.save, "Saved the payload without content"
  end

  test "should not save payload with content exceeding maximum length" do
    payload = Payload.new(content: "a" * (Payload::MAX_CONTENT_SIZE + 1))
    assert_not payload.save, "Saved the payload with content exceeding maximum length"
  end

  test "should save valid payload" do
    payload = Payload.new(content: "Valid content", mime_type: "text/plain")
    assert payload.save, "Could not save valid payload"
  end

  test "should set default mime_type if not provided" do
    payload = Payload.create(content: "Content")
    assert_equal "text/plain", payload.mime_type, "Did not set default mime_type"
  end

  test "should set expiry_time on creation" do
    payload = Payload.create(content: "Content")
    assert_not_nil payload.expiry_time, "Did not set expiry_time on creation"
  end

  test "should not save payload with expiry_time exceeding maximum allowed" do
    payload = Payload.new(content: "Content", expiry_time: 31.days.from_now)
    assert payload.save, "Could not save payload with expiry_time exceeding maximum allowed"
    assert_in_delta 30.days.from_now, payload.expiry_time, 1.second, "Did not adjust expiry_time to maximum allowed"
  end
end
