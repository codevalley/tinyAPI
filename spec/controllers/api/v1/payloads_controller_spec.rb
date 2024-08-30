require "rails_helper"

RSpec.describe Api::V1::PayloadsController, type: :controller do
  let(:client_token) { "test_token" }
  let(:valid_attributes) { { content: "Test content" } }
  let(:invalid_attributes) { { content: nil } }

  before do
    request.headers["X-Client-Token"] = client_token
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
        expect(JSON.parse(response.body)).to include("hash_id", "content")
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

    context "with payload exceeding size limit" do
      let(:large_payload) { { content: "a" * (PayloadService::MAX_CONTENT_SIZE + 1) } }

      it "returns unprocessable entity" do
        post :create, params: { payload: large_payload }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)["errors"]).to include("Content is too large")
      end
    end
  end

  describe "PUT #update" do
    let(:payload) { PayloadService.create(valid_attributes, client_token).payload }

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
        expect(response.content_type).to include("application/json")
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
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to eq("application/json; charset=utf-8")
        expect(JSON.parse(response.body)).to have_key("errors")
      end
    end

    context "with different client token" do
      it "returns not found" do
        request.headers["X-Client-Token"] = "different_token"
        put :update, params: { hash_id: payload.hash_id, payload: { content: "Updated content" } }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)).to have_key("errors")
      end
    end
  end

  describe "GET #show" do
    let(:payload) { PayloadService.create(valid_attributes, client_token).payload }

    it "renders a JSON response with the payload" do
      get :show, params: { hash_id: payload.hash_id }
      expect(response).to have_http_status(:ok)
      expect(response.content_type).to eq("application/json; charset=utf-8")
      expect(JSON.parse(response.body)).to include("hash_id", "content")
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
        expect(JSON.parse(response.body)).to have_key("error")
      end
    end

    context "with expired payload" do
      let!(:expired_payload) {
 PayloadService.create({ content: "Expired", expiry_time: 1.second.ago }, client_token).payload }

      it "returns not found" do
        get :show, params: { hash_id: expired_payload.hash_id }
        expect(response).to have_http_status(:not_found)
      end
    end
  end
end
