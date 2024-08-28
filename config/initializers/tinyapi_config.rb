Rails.application.config.tinyapi = ActiveSupport::OrderedOptions.new
Rails.application.config.tinyapi.max_payload_size = 10.megabytes
Rails.application.config.tinyapi.default_expiry_days = 7
Rails.application.config.tinyapi.max_expiry_days = 30
Rails.application.config.tinyapi.rate_limits = {
  add: 100,
  edit: 50,
  get: 1000
}
