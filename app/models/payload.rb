class Payload < ApplicationRecord
  validates :hash_id, presence: true, uniqueness: true
  validates :content, presence: true
  validates :mime_type, presence: true
  validates :expiry_time, presence: true
  validate :content_size_within_limit
  validate :expiry_time_within_limit

  before_validation :set_default_expiry_time, on: :create
  before_save :sanitize_content

  private

  def content_size_within_limit
    return unless content.present?

    max_size = Rails.configuration.tinyapi.max_payload_size
    errors.add(:content, "size exceeds the limit of #{max_size} bytes") if content.bytesize > max_size
  end

  def set_default_expiry_time
    self.expiry_time ||= Time.current + Rails.configuration.tinyapi.default_expiry_days.days
  end

  def expiry_time_within_limit
    return unless expiry_time.present?

    max_expiry = Time.current + Rails.configuration.tinyapi.max_expiry_days.days
    self.expiry_time = [ expiry_time, max_expiry ].min
  end

  def sanitize_content
    self.content = ActionController::Base.helpers.sanitize(content)
  end
end
