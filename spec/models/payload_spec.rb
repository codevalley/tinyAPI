require "rails_helper"

RSpec.describe Payload, type: :model do
  let(:valid_attributes) { { content: "Test content", client_token: "test_token" } }

  describe "validations" do
    it "validates presence of hash_id" do
      payload = Payload.new(valid_attributes)
      expect(payload).to be_valid
      expect(payload.hash_id).to be_present
    end

    it "validates presence of mime_type" do
      payload = Payload.new(valid_attributes)
      expect(payload).to be_valid
      expect(payload.mime_type).to eq("text/plain")
    end

    it "sets a default mime_type if not provided" do
      payload = Payload.new(valid_attributes)
      expect(payload).to be_valid
      expect(payload.mime_type).to eq("text/plain")
    end

    it "sets a default hash_id if not provided" do
      payload = Payload.new(valid_attributes)
      expect(payload).to be_valid
      expect(payload.hash_id).to be_present
    end

    it "sets a default expiry_time if not provided" do
      payload = Payload.new(valid_attributes)
      expect(payload).to be_valid
      expect(payload.expiry_time).to be_within(1.second).of(30.days.from_now)
    end

    # ... (keep the rest of the specs as is)
  end
end
