FactoryBot.define do
  factory :payload do
    hash_id { SecureRandom.hex(10) }
    content { "Test content" }
    mime_type { "text/plain" }
    expiry_time { 1.day.from_now }
  end
end