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

  describe "#perform_later" do
    it "is enqueued with the correct queue" do
      expect {
        DeleteExpiredPayloadsJob.perform_later
      }.to have_enqueued_job(DeleteExpiredPayloadsJob).on_queue("default")
    end
  end
end
