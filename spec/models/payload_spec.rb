require "rails_helper"

RSpec.describe Payload, type: :model do
  describe "validations" do
    subject { Payload.new(content: "Test content") }

    it { should validate_presence_of(:content) }

    it "validates presence of hash_id" do
      payload = Payload.new(content: "Test content", skip_callbacks: true)
      expect(payload).to be_invalid
      expect(payload.errors[:hash_id]).to include("can't be blank")
    end

    it "validates presence of mime_type" do
      payload = Payload.new(content: "Test content", skip_callbacks: true)
      expect(payload).to be_invalid
      expect(payload.errors[:mime_type]).to include("can't be blank")
    end

    it { should validate_uniqueness_of(:hash_id) }

    it "sets a default mime_type if not provided" do
      payload = Payload.new(content: "Test content")
      payload.valid?
      expect(payload.mime_type).to eq("text/plain")
    end

    it "sets a default hash_id if not provided" do
      payload = Payload.new(content: "Test content")
      payload.valid?
      expect(payload.hash_id).to be_present
    end

    it "sets a default expiry_time if not provided" do
      payload = Payload.new(content: "Test content")
      payload.valid?
      expect(payload.expiry_time).to be_within(1.second).of(30.days.from_now)
    end
  end

  describe "content_size_within_limit" do
    it "is invalid when content size exceeds the limit" do
      payload = Payload.new(content: "a" * (Payload::MAX_CONTENT_SIZE + 1))
      payload.valid?
      expect(payload.errors[:content]).to include("size exceeds the limit of #{Payload::MAX_CONTENT_SIZE} bytes")
    end

    it "is valid when content size is within the limit" do
      payload = Payload.new(content: "a" * Payload::MAX_CONTENT_SIZE)
      payload.valid?
      expect(payload.errors[:content]).to be_empty
    end
  end

  describe "expiry_time_within_limit" do
    it "sets expiry_time to the maximum allowed when it exceeds the limit" do
      payload = Payload.new(content: "Test", expiry_time: 31.days.from_now)
      payload.valid?
      expect(payload.expiry_time).to be_within(1.second).of(30.days.from_now)
    end

    it "does not change expiry_time when it's within the limit" do
      expiry_time = 29.days.from_now
      payload = Payload.new(content: "Test", expiry_time: expiry_time)
      payload.valid?
      expect(payload.expiry_time).to be_within(1.second).of(expiry_time)
    end
  end
end
