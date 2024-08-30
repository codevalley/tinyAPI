require "test_helper"

class PayloadTest < ActiveSupport::TestCase
  test "should save valid payload" do
    payload = Payload.new(content: "Test content", client_token: "test_token")
    assert payload.save, "Could not save valid payload"
  end

  test "should not save payload without content" do
    payload = Payload.new(client_token: "test_token")
    assert_not payload.save, "Saved the payload without content"
  end

  test "should not save payload with expiry_time exceeding maximum allowed" do
    payload = Payload.new(content: "Test content", client_token: "test_token", expiry_time: 31.days.from_now)
    assert payload.save, "Could not save payload with expiry_time exceeding maximum allowed"
    assert_equal 30.days.from_now.to_date, payload.expiry_time.to_date,
"Expiry time was not adjusted to maximum allowed"
  end

  # ... (keep other tests as is)
end
