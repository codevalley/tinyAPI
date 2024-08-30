require 'rails_helper'

RSpec.describe PayloadService do
  let(:client_token) { 'test-token' }
  let(:valid_params) { { content: 'Test content', expiry_time: 1.day.from_now } }

  describe '.create' do
    it 'creates a new payload' do
      expect {
        PayloadService.create(valid_params, client_token)
      }.to change(Payload, :count).by(1)
    end

    it 'sets the client token' do
      payload = PayloadService.create(valid_params, client_token)
      expect(payload.client_token).to eq(client_token)
    end

    it 'raises an error for invalid params' do
      expect {
        PayloadService.create({ content: '' }, client_token)
      }.to raise_error(ActiveRecord::RecordInvalid)
    end
  end

  describe '.update' do
    let!(:payload) { create(:payload, client_token: client_token) }

    it 'updates an existing payload' do
      updated_payload = PayloadService.update(payload.hash_id, { content: 'Updated content' }, client_token)
      expect(updated_payload.content).to eq('Updated content')
    end

    it 'raises an error for non-existent payload' do
      expect {
        PayloadService.update('non-existent', { content: 'Updated content' }, client_token)
      }.to raise_error(ActiveRecord::RecordNotFound)
    end

    it 'raises an error for invalid params' do
      expect {
        PayloadService.update(payload.hash_id, { content: '' }, client_token)
      }.to raise_error(ActiveRecord::RecordInvalid)
    end
  end

  describe '.find' do
    let!(:payload) { create(:payload, client_token: client_token) }

    it 'finds an existing payload' do
      found_payload = PayloadService.find(payload.hash_id, client_token)
      expect(found_payload).to eq(payload)
    end

    it 'updates the viewed_at timestamp' do
      expect {
        PayloadService.find(payload.hash_id, client_token)
        payload.reload
      }.to change(payload, :viewed_at)
    end

    it 'raises an error for non-existent payload' do
      expect {
        PayloadService.find('non-existent', client_token)
      }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end
end
