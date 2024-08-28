require 'rails_helper'

RSpec.describe Payload, type: :model do
  describe 'validations' do
    subject { build(:payload, expiry_time: nil) }
    
    it { should validate_presence_of(:hash_id) }
    it { should validate_uniqueness_of(:hash_id) }
    it { should validate_presence_of(:content) }
    it { should validate_presence_of(:mime_type) }
    
    it 'sets a default expiry_time if not provided' do
      expect(subject.expiry_time).to be_nil
      subject.valid?
      expect(subject.expiry_time).to be_within(1.second).of(Time.current + Rails.configuration.tinyapi.default_expiry_days.days)
    end
  end

  describe 'content_size_within_limit' do
    let(:payload) { build(:payload, content: 'a' * (Rails.configuration.tinyapi.max_payload_size + 1)) }

    it 'is invalid when content size exceeds the limit' do
      expect(payload).to be_invalid
      expect(payload.errors[:content]).to include("size exceeds the limit of #{Rails.configuration.tinyapi.max_payload_size} bytes")
    end
  end

  describe 'expiry_time_within_limit' do
    let(:payload) { build(:payload, expiry_time: Time.current + (Rails.configuration.tinyapi.default_expiry_days + 1).days) }

    it 'sets expiry_time to the maximum allowed when it exceeds the limit' do
      payload.valid?
      expect(payload.expiry_time).to be_within(1.second).of(Time.current + Rails.configuration.tinyapi.default_expiry_days.days)
    end
  end
end