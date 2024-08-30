class DeleteExpiredPayloadsJob < ApplicationJob
  queue_as :default

  def perform
    Payload.where("expiry_time <= ?", Time.current).destroy_all
  end
end
