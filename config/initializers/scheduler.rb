require "rufus-scheduler"

scheduler = Rufus::Scheduler.singleton

scheduler.every "1h" do
  AutoDeleteExpiredPayloadsJob.perform_later
end
