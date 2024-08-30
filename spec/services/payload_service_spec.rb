require 'rails_helper'

RSpec.describe PayloadService, type: :service do
  let(:client_token) { "test-token" }
  let(:valid_attributes) { { content: "Test content", expiry_time: 1.day.from_now } }

  describe ".create" do
    it "creates a new payload" do
      result = PayloadService.create(valid_attributes, client_token)
      expect(result.success?).to be true
      expect(result.payload).to be_persisted
    end

    it "generates a unique hash_id" do
      result1 = PayloadService.create(valid_attributes, client_token)
      result2 = PayloadService.create(valid_attributes, client_token)
      expect(result1.payload.hash_id).not_to eq(result2.payload.hash_id)
    end

    it "sets default expiry_time if not provided" do
      result = PayloadService.create({ content: "Test content" }, client_token)
      expect(result.payload.expiry_time).to be_within(1.second).of(30.days.from_now)
    end
  end

  describe ".update" do
    let(:payload) { PayloadService.create(valid_attributes, client_token).payload }

    it "updates an existing payload" do
      result = PayloadService.update(payload.hash_id, { content: "Updated content" }, client_token)
      expect(result.success?).to be true
      expect(result.payload.content).to eq("Updated content")
    end

    it "returns errors for non-existent payload" do
      result = PayloadService.update("non-existent", { content: "Updated content" }, client_token)
      expect(result.success?).to be false
      expect(result.errors).to include("Payload not found")
    end
  end

  describe ".find" do
    let(:payload) { PayloadService.create(valid_attributes, client_token).payload }

    it "finds an existing payload" do
      result = PayloadService.find(payload.hash_id, client_token)
      expect(result).to eq(payload)
    end

    it "returns nil for non-existent payload" do
      result = PayloadService.find("non-existent", client_token)
      expect(result).to be_nil
    end

    it "updates viewed_at timestamp" do
      expect {
        PayloadService.find(payload.hash_id, client_token)
        payload.reload
      }.to change(payload, :viewed_at)
    end
  end
end
