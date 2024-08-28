class AutoDeleteExpiredPayloadsJob < ApplicationJob
  queue_as :default

  def perform
    Payload.where('expiry_time <= ?', Time.current).delete_all
    Payload.where('viewed_at <= ?', 6.days.ago).delete_all
  end
end