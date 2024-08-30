class DeleteExpiredPayloadsJob < ApplicationJob
  queue_as :default

  def perform
    expired_payloads = Payload.where("expiry_time < ? OR (viewed_at < ? AND created_at < ?)",
                                     Time.current, 6.days.ago, 6.days.ago)
    count = expired_payloads.delete_all
    Rails.logger.info("Deleted #{count} expired payloads")
  end
end
