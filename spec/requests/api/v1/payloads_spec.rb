require "rails_helper"

RSpec.describe "Api::V1::Payloads", type: :request do
  let(:client_token) { "test_token" }
  let(:headers) { { "X-Client-Token" => client_token } }
  let(:valid_attributes) { { content: "Test content" } }
  let(:invalid_attributes) { { content: nil } }

  describe "POST /api/v1/payloads" do
    context "with valid parameters" do
      it "creates a new Payload" do
        expect {
          post api_v1_payloads_path, params: { payload: valid_attributes }, headers: headers
        }.to change(Payload, :count).by(1)
        expect(response).to have_http_status(:created)
      end
    end

    context "with invalid parameters" do
      it "does not create a new Payload" do
        expect {
          post api_v1_payloads_path, params: { payload: invalid_attributes }, headers: headers
        }.to change(Payload, :count).by(0)
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "PUT /api/v1/payloads/:hash_id" do
    let(:payload) { PayloadService.create(valid_attributes, client_token).payload }

    context "with valid parameters" do
      let(:new_attributes) { { content: "Updated content" } }

      it "updates the requested payload" do
        put api_v1_payload_path(hash_id: payload.hash_id), params: { payload: new_attributes }, headers: headers
        payload.reload
        expect(payload.content).to eq("Updated content")
      end
    end

    context "with invalid parameters" do
      it "renders a JSON response with errors" do
        put api_v1_payload_path(hash_id: payload.hash_id), params: { payload: invalid_attributes }, headers: headers
        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)).to have_key("errors")
      end
    end

    context "with non-existent payload" do
      it "renders a JSON response with a not found error" do
        put api_v1_payload_path(hash_id: "non_existent"), params: { payload: valid_attributes }, headers: headers
        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)).to have_key("errors")
      end
    end
  end

  describe "GET /api/v1/payloads/:hash_id" do
    let(:payload) { PayloadService.create(valid_attributes, client_token).payload }

    it "renders a successful response" do
      get api_v1_payload_path(hash_id: payload.hash_id), headers: headers
      expect(response).to be_successful
    end

    it "updates the viewed_at timestamp" do
      expect {
        get api_v1_payload_path(hash_id: payload.hash_id), headers: headers
        payload.reload
      }.to change(payload, :viewed_at)
    end
  end
end
