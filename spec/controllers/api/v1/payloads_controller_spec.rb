require "rails_helper"

RSpec.describe Api::V1::PayloadsController, type: :controller do
  let(:valid_attributes) { { content: "Test content", mime_type: "text/plain", expiry_time: 1.day.from_now } }
  let(:invalid_attributes) { { content: "", mime_type: "", expiry_time: nil } }
  let(:valid_headers) { { "X-Client-Token" => "test-token" } }

  before do
    request.headers.merge!(valid_headers)
  end

  describe "POST #create" do
    context "with valid params" do
      it "creates a new Payload" do
        expect {
          post :create, params: { payload: valid_attributes }
        }.to change(Payload, :count).by(1)
      end

      it "renders a JSON response with the new payload" do
        post :create, params: { payload: valid_attributes }
        expect(response).to have_http_status(:created)
        expect(response.content_type).to eq("application/json; charset=utf-8")
        expect(JSON.parse(response.body)).to include("hash_id", "content", "mime_type", "expiry_time")
      end
    end

    context "with invalid params" do
      it "renders a JSON response with errors" do
        post :create, params: { payload: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to eq("application/json; charset=utf-8")
        expect(JSON.parse(response.body)).to have_key("errors")
      end
    end

    context "without client token" do
      it "returns unauthorized" do
        request.env.delete("HTTP_X_CLIENT_TOKEN")
        post :create, params: { payload: "Test payload" }
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe "PUT #update" do
    let!(:payload) { create(:payload, client_token: "test-token") }

    context "with valid params" do
      let(:new_attributes) { { content: "Updated content" } }

      it "updates the requested payload" do
        put :update, params: { hash_id: payload.hash_id, payload: new_attributes }
        payload.reload
        expect(payload.content).to eq("Updated content")
      end

      it "renders a JSON response with the payload" do
        put :update, params: { hash_id: payload.hash_id, payload: new_attributes }
        expect(response).to have_http_status(:ok)
        expect(response.content_type).to eq("application/json; charset=utf-8")
        expect(JSON.parse(response.body)["content"]).to eq("Updated content")
      end
    end

    context "with invalid params" do
      it "renders a JSON response with errors" do
        put :update, params: { hash_id: payload.hash_id, payload: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to eq("application/json; charset=utf-8")
        expect(JSON.parse(response.body)).to have_key("errors")
      end
    end

    context "with non-existent payload" do
      it "renders a JSON response with a not found error" do
        put :update, params: { hash_id: "non-existent", payload: valid_attributes }
        expect(response).to have_http_status(:not_found)
        expect(response.content_type).to eq("application/json; charset=utf-8")
        expect(JSON.parse(response.body)).to have_key("errors")
      end
    end
  end

  describe "GET #show" do
    let!(:payload) { create(:payload, client_token: "test-token") }

    it "renders a JSON response with the payload" do
      get :show, params: { hash_id: payload.hash_id }
      expect(response).to have_http_status(:ok)
      expect(response.content_type).to eq("application/json; charset=utf-8")
      expect(JSON.parse(response.body)).to include("hash_id", "content", "mime_type", "expiry_time")
    end

    it "updates the viewed_at timestamp" do
      expect {
        get :show, params: { hash_id: payload.hash_id }
        payload.reload
      }.to change(payload, :viewed_at)
    end

    context "with non-existent payload" do
      it "renders a JSON response with a not found error" do
        get :show, params: { hash_id: "non-existent" }
        expect(response).to have_http_status(:not_found)
        expect(response.content_type).to eq("application/json; charset=utf-8")
        expect(JSON.parse(response.body)).to have_key("errors")
      end
    end
  end
end
