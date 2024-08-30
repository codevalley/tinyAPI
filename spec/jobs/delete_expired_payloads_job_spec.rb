require 'rails_helper'
require 'fakeredis'

RSpec.describe DeleteExpiredPayloadsJob, type: :job do
  include ActiveJob::TestHelper

  let!(:expired_payload) { create(:payload, expiry_time: 1.hour.ago) }
  let!(:valid_payload) { create(:payload, expiry_time: 1.hour.from_now) }

  it 'deletes expired payloads' do
    expect {
      DeleteExpiredPayloadsJob.perform_now
    }.to change(Payload, :count).by(-1)

    expect(Payload.exists?(expired_payload.id)).to be false
    expect(Payload.exists?(valid_payload.id)).to be true
  end
end
