FactoryBot.define do
  factory :payload do
    content { "Test content" }
    client_token { "test-token" }
    mime_type { "text/plain" }
    expiry_time { 1.day.from_now }
    hash_id { SecureRandom.hex(10) }
    viewed_at { nil }
  end
end
