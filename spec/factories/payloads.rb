FactoryBot.define do
  factory :payload do
    content { "Test content" }
    mime_type { "text/plain" }
    expiry_time { 1.day.from_now }
    client_token { "test-token" }
    sequence(:hash_id) { |n| "hash#{n}" }
  end
end
