class Payload < ApplicationRecord
  MAX_CONTENT_SIZE = 1.megabyte
  MAX_EXPIRY_TIME = 30.days

  validates :content, presence: true
  validates :hash_id, presence: true, uniqueness: true
  validates :client_token, presence: true
  validates :expiry_time, presence: true
  validate :content_size_within_limit
  validate :expiry_time_within_limit

  before_validation :set_default_values

  private

  def set_default_values
    self.mime_type ||= "text/plain"
    self.hash_id ||= SecureRandom.alphanumeric(8)
    self.expiry_time ||= 30.days.from_now
    self.viewed_at ||= Time.current
  end

  def content_size_within_limit
    return if content.blank?

    if content.bytesize > MAX_CONTENT_SIZE
      errors.add(:content, "size exceeds the limit of #{MAX_CONTENT_SIZE} bytes")
    end
  end

  def expiry_time_within_limit
    return if expiry_time.blank?

    if expiry_time > MAX_EXPIRY_TIME.from_now
      self.expiry_time = MAX_EXPIRY_TIME.from_now
    end
  end
end
