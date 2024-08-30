require 'rails_helper'
require 'fakeredis'

RSpec.describe DeleteExpiredPayloadsJob, type: :job do
  include ActiveJob::TestHelper

  let!(:expired_payload) { create(:payload, expiry_time: 1.hour.ago) }
  let!(:valid_payload) { create(:payload, expiry_time: 1.hour.from_now) }
  let!(:just_expired_payload) { create(:payload, expiry_time: 1.second.ago) }

  it 'deletes expired payloads' do
    expect {
      DeleteExpiredPayloadsJob.perform_now
    }.to change(Payload, :count).by(-2)

    expect(Payload.exists?(expired_payload.id)).to be false
    expect(Payload.exists?(just_expired_payload.id)).to be false
    expect(Payload.exists?(valid_payload.id)).to be true
  end

  it 'does not delete valid payloads' do
    DeleteExpiredPayloadsJob.perform_now
    expect(Payload.exists?(valid_payload.id)).to be true
  end

  it 'logs the number of deleted payloads' do
    allow(Rails.logger).to receive(:info)
    DeleteExpiredPayloadsJob.perform_now
    expect(Rails.logger).to have_received(:info).with(/Deleted \d+ expired payloads/)
  end

  # ... other tests ...
end
