require "rails_helper"

RSpec.describe "Api::V1::Payloads", type: :request do
  let(:valid_attributes) {
    { content: "Test content", mime_type: "text/plain", expiry_time: 1.day.from_now }
  }

  let(:invalid_attributes) {
    { content: "", mime_type: "", expiry_time: nil }
  }

  let(:valid_headers) {
    { "X-Client-Token" => "test_token", "CONTENT_TYPE" => "application/json" }
  }

  describe "POST /api/v1/payloads" do
    context "with valid parameters" do
      it "creates a new Payload" do
        expect {
          post api_v1_payloads_path, params: { payload: valid_attributes }.to_json, headers: valid_headers
        }.to change(Payload, :count).by(1)
        expect(response).to have_http_status(:created)
      end
    end

    context "with invalid parameters" do
      it "does not create a new Payload" do
        post api_v1_payloads_path, params: { payload: invalid_attributes }.to_json, headers: valid_headers
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "PUT /api/v1/payloads/:hash_id" do
    let!(:payload) { create(:payload) }

    context "with valid parameters" do
      let(:new_attributes) { { content: "Updated content" } }

      it "updates the requested payload" do
        put api_v1_payload_path(payload.hash_id), params: { payload: new_attributes }.to_json, headers: valid_headers
        payload.reload
        expect(payload.content).to eq("Updated content")
        expect(response).to have_http_status(:ok)
      end
    end

    context "with invalid parameters" do
      it "renders a JSON response with errors" do
        put api_v1_payload_path(payload.hash_id), params: { payload: invalid_attributes }.to_json,
headers: valid_headers
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

    context "with non-existent payload" do
      it "renders a JSON response with a not found error" do
        put api_v1_payload_path("non_existent"), params: { payload: valid_attributes }.to_json, headers: valid_headers
        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe "GET /api/v1/payloads/:hash_id" do
    let!(:payload) { create(:payload) }

    it "renders a successful response" do
      get api_v1_payload_path(payload.hash_id), headers: valid_headers
      expect(response).to be_successful
    end

    it "updates the viewed_at timestamp" do
      expect {
        get api_v1_payload_path(payload.hash_id), headers: valid_headers
        payload.reload
      }.to change(payload, :viewed_at)
    end
  end
end
