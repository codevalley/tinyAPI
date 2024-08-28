require "rails_helper"

RSpec.describe Api::V1::PayloadsController, type: :controller do
  let(:valid_attributes) {
    { content: "Test content", mime_type: "text/plain", expiry_time: 1.day.from_now }
  }

  let(:invalid_attributes) {
    { content: "", mime_type: "", expiry_time: nil }
  }

  let(:valid_headers) {
    { "X-Client-Token" => "test_token" }
  }

  describe "POST #add" do
    context "with valid params" do
      it "creates a new Payload" do
        expect {
          request.headers.merge!(valid_headers)
          post :add, params: { payload: valid_attributes }
        }.to change(Payload, :count).by(1)
      end

      it "renders a JSON response with the new payload" do
        request.headers.merge!(valid_headers)
        post :add, params: { payload: valid_attributes }
        expect(response).to have_http_status(:created)
        expect(response.content_type).to eq("application/json; charset=utf-8")
        expect(JSON.parse(response.body)).to include("hash_id", "content", "mime_type", "expiry_time")
      end
    end

    context "with invalid params" do
      it "renders a JSON response with errors" do
        request.headers.merge!(valid_headers)
        post :add, params: { payload: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to eq("application/json; charset=utf-8")
        expect(JSON.parse(response.body)).to have_key("errors")
      end
    end
  end

  describe "PUT #edit" do
    let!(:payload) { create(:payload) }

    context "with valid params" do
      let(:new_attributes) {
        { content: "Updated content" }
      }

      it "updates the requested payload" do
        request.headers.merge!(valid_headers)
        put :edit, params: { hash_id: payload.hash_id, payload: new_attributes }
        payload.reload
        expect(payload.content).to eq("Updated content")
      end

      it "renders a JSON response with the payload" do
        request.headers.merge!(valid_headers)
        put :edit, params: { hash_id: payload.hash_id, payload: new_attributes }
        expect(response).to have_http_status(:ok)
        expect(response.content_type).to eq("application/json; charset=utf-8")
        expect(JSON.parse(response.body)["content"]).to eq("Updated content")
      end
    end

    context "with invalid params" do
      it "renders a JSON response with errors" do
        request.headers.merge!(valid_headers)
        put :edit, params: { hash_id: payload.hash_id, payload: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to eq("application/json; charset=utf-8")
        expect(JSON.parse(response.body)).to have_key("errors")
      end
    end
  end

  describe "GET #get" do
    let!(:payload) { create(:payload) }

    it "renders a JSON response with the payload" do
      request.headers.merge!(valid_headers)
      get :get, params: { hash_id: payload.hash_id }
      expect(response).to have_http_status(:ok)
      expect(response.content_type).to eq("application/json; charset=utf-8")
      expect(JSON.parse(response.body)).to include("hash_id", "content", "mime_type", "expiry_time")
    end

    it "updates the viewed_at timestamp" do
      expect {
        request.headers.merge!(valid_headers)
        get :get, params: { hash_id: payload.hash_id }
        payload.reload
      }.to change(payload, :viewed_at)
    end

    context "when payload doesn't exist" do
      it "renders a JSON response with errors" do
        request.headers.merge!(valid_headers)
        get :get, params: { hash_id: "nonexistent" }
        expect(response).to have_http_status(:not_found)
        expect(response.content_type).to eq("application/json; charset=utf-8")
        expect(JSON.parse(response.body)).to have_key("error")
      end
    end
  end
end
