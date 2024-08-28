require 'rails_helper'

RSpec.describe "Api::V1::Payloads", type: :request do
  let(:valid_headers) {
    { "X-Client-Token" => "test_token", "CONTENT_TYPE" => "application/json" }
  }

  describe "POST /api/v1/add" do
    let(:valid_attributes) {
      { payload: { content: "Test content", mime_type: "text/plain", expiry_time: 1.day.from_now } }
    }

    context "with valid parameters" do
      it "creates a new Payload" do
        expect {
          post "/api/v1/add", params: valid_attributes.to_json, headers: valid_headers
        }.to change(Payload, :count).by(1)
        
        expect(response).to have_http_status(:created)
        expect(response.content_type).to match(a_string_including("application/json"))
      end
    end

    context "with invalid parameters" do
      it "does not create a new Payload" do
        expect {
          post "/api/v1/add", params: { payload: { content: "" } }.to_json, headers: valid_headers
        }.to change(Payload, :count).by(0)
        
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to match(a_string_including("application/json"))
      end
    end
  end

  describe "PUT /api/v1/edit/:hash_id" do
    let!(:payload) { create(:payload) }

    context "with valid parameters" do
      it "updates the requested payload" do
        put "/api/v1/edit/#{payload.hash_id}", 
            params: { payload: { content: "Updated content" } }.to_json, 
            headers: valid_headers

        payload.reload
        expect(payload.content).to eq("Updated content")
        expect(response).to have_http_status(:ok)
        expect(response.content_type).to match(a_string_including("application/json"))
      end
    end

    context "with invalid parameters" do
      it "renders a JSON response with errors" do
        put "/api/v1/edit/#{payload.hash_id}", 
            params: { payload: { content: "" } }.to_json, 
            headers: valid_headers

        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to match(a_string_including("application/json"))
      end
    end
  end

  describe "GET /api/v1/get/:hash_id" do
    let!(:payload) { create(:payload) }

    it "renders a successful response" do
      get "/api/v1/get/#{payload.hash_id}", headers: valid_headers
      expect(response).to be_successful
    end

    it "updates the viewed_at timestamp" do
      expect {
        get "/api/v1/get/#{payload.hash_id}", headers: valid_headers
        payload.reload
      }.to change(payload, :viewed_at)
    end

    context "when payload doesn't exist" do
      it "renders a JSON response with errors" do
        get "/api/v1/get/nonexistent", headers: valid_headers
        expect(response).to have_http_status(:not_found)
      end
    end
  end
end