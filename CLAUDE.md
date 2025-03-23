# TinyAPI - Agent Guidelines

## Build/Development Commands
- Start server: `rails server`
- Start background jobs: `bundle exec sidekiq`
- Run all tests: `bundle exec rspec && bundle exec rails test`
- Run specific RSpec test: `bundle exec rspec spec/path/to/spec_file.rb:line_number`
- Run specific Rails test: `bundle exec rails test test/path/to/test_file.rb:line_number`
- Lint code: `rubocop -A` (with auto-fix) or `rubocop` (check only)
- Database setup: `rails db:create db:migrate`

## Code Style Guidelines
- Ruby version 3.3.4, Rails 8.0.2
- Double quotes for strings
- Max line length: 120 characters, max method length: 20 lines
- Use ActiveSupport::Concern for shared module functionality
- Error handling via centralized ErrorHandler concern
- Service objects return OpenStruct with success? method
- Controller naming: plural (PayloadsController)
- Model naming: singular (Payload)
- Strong params in controllers, validations in models
- Concerns for reusable controller/model functionality
- RSpec and Minitest frameworks used for testing
- Namespacing pattern: Api::V1::ResourceController
- Prefer service objects for complex business logic