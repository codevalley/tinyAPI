require "sidekiq"
require "sidekiq-scheduler"

redis_config = if Rails.env.test?
                 { url: "redis://localhost:6379/0" }
else
                 { url: ENV["REDIS_URL"] || "redis://localhost:6379/0" }
end

Sidekiq.configure_server do |config|
  config.redis = redis_config

  if Rails.env.production?
    config.on(:startup) do
      schedule_file = File.expand_path("../../sidekiq.yml", __FILE__)
      if File.exist?(schedule_file)
        Sidekiq.schedule = YAML.load_file(schedule_file)
        SidekiqScheduler::Scheduler.instance.reload_schedule!
      end
    end
  end
end

Sidekiq.configure_client do |config|
  config.redis = redis_config
end
