require "rails_helper"

RSpec.describe Payload, type: :model do
  describe "validations" do
    subject { build(:payload, expiry_time: nil) }

    it { should validate_presence_of(:hash_id) }
    it { should validate_uniqueness_of(:hash_id) }
    it { should validate_presence_of(:content) }
    it { should validate_presence_of(:mime_type) }

    it "sets a default expiry_time if not provided" do
      expect(subject.expiry_time).to be_nil
      subject.valid?
      expected_expiry = Time.current + Rails.configuration.tinyapi.default_expiry_days.days
      expect(subject.expiry_time).to be_within(1.second).of(expected_expiry)
    end

    it "sets the expiry_time to the default if not provided" do
      subject.save
      expected_expiry = Time.current + Rails.configuration.tinyapi.default_expiry_days.days
      expect(subject.expiry_time).to be_within(1.second).of(expected_expiry)
    end
  end

  describe "content_size_within_limit" do
    let(:payload) { build(:payload, content: "a" * (Rails.configuration.tinyapi.max_payload_size + 1)) }

    it "is invalid when content size exceeds the limit" do
      expect(payload).to be_invalid
      max_size = Rails.configuration.tinyapi.max_payload_size
      error_message = "size exceeds the limit of #{max_size} bytes"
      expect(payload.errors[:content]).to include(error_message)
    end

    it "validates the content size" do
      max_size = Rails.configuration.tinyapi.max_payload_size
      payload.content = "a" * (max_size + 1)
      expect(payload).to be_invalid
      error_message = "size exceeds the limit of #{max_size} bytes"
      expect(payload.errors[:content]).to include(error_message)
    end
  end

  describe "expiry_time_within_limit" do
    let(:payload) do
      build(:payload,
            expiry_time: Time.current + (Rails.configuration.tinyapi.max_expiry_days + 1).days)
    end

    it "sets expiry_time to the maximum allowed when it exceeds the limit" do
      payload.valid?
      max_expiry = Time.current + Rails.configuration.tinyapi.max_expiry_days.days
      expect(payload.expiry_time).to be_within(1.second).of(max_expiry)
    end

    it "limits the expiry_time to the maximum allowed" do
      max_expiry = Time.current + Rails.configuration.tinyapi.max_expiry_days.days
      payload.expiry_time = max_expiry + 1.day
      payload.save
      expect(payload.expiry_time).to be_within(1.second).of(max_expiry)
    end
  end
end
