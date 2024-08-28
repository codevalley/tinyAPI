class Payload < ApplicationRecord
  MAX_CONTENT_SIZE = 10.megabytes
  MAX_EXPIRY_TIME = 30.days

  attr_accessor :skip_callbacks

  validates :content, presence: true, length: { maximum: MAX_CONTENT_SIZE }
  validates :mime_type, presence: true
  validates :hash_id, presence: true, uniqueness: true
  validate :content_size_within_limit
  validate :expiry_time_within_limit

  before_validation :set_default_values, unless: :skip_callbacks

  private

  def set_default_values
    set_default_mime_type
    set_hash_id
    set_expiry_time
  end

  def set_default_mime_type
    self.mime_type ||= "text/plain"
  end

  def set_hash_id
    self.hash_id ||= SecureRandom.hex(10)
  end

  def set_expiry_time
    self.expiry_time ||= MAX_EXPIRY_TIME.from_now
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
