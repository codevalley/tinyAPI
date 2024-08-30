# TinyAPI

[![CI Status](https://github.com/codevalley/tinyapi/workflows/CI/badge.svg)](https://github.com/codevalley/tinyapi/actions)
[![codecov](https://codecov.io/gh/codevalley/tinyapi/branch/main/graph/badge.svg)](https://codecov.io/gh/codevalley/tinyapi)

TinyAPI is a simple storage service that allows users to save and edit payloads through a RESTful API. It's built with Ruby on Rails and uses Redis for rate limiting.

## Features

- Create, read, and update payloads
- Automatic payload expiration
- Rate limiting
- Configurable payload size and expiry time

## Getting Started

### Prerequisites

- Ruby 3.3.4
- Rails 7.2.1
- Redis
- Docker
- Kamal

### Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/your-username/tinyapi.git
   cd tinyapi
   ```

2. Install dependencies:
   ```bash
   bundle install
   ```

3. Set up the database:
   ```bash
   rails db:create db:migrate
   ```

4. Start the Redis server:
   ```bash
   redis-server
   ```

5. Start the Rails server:
   ```bash
   rails server
   ```
## Testing

Before any deployment, I prefer to run the below commands, to ensure everything is working fine.
```bash
rubocop -A # check lint enforcement
bundle exec rspec # check test coverage
bundle exec rails test # check unit test coverage
rails server # to locally start the server
```
## Deployment

This project uses Kamal for deployment. Follow these steps to deploy:

1. Ensure you have Kamal installed:
   ```bash
   gem install kamal
   ```

2. Set up your `.env` file with the necessary environment variables (see `.env.example` for required variables).

3. Build and push your Docker image:
   ```bash
   docker build -t your-docker-hub-username/tinyapi:latest .
   docker push your-docker-hub-username/tinyapi:latest
   ```

4. Deploy your application:
   ```bash
   kamal setup
   kamal deploy
   ```

## Deployment Configuration

The main deployment configuration is in `config/deploy.yml`. This file defines:

- The Docker image to use
- The server(s) to deploy to
- Environment variables
- Accessory services (like Redis)
- Traefik configuration for SSL

## Deployment Hooks

Sample Kamal deployment hooks are available in the `.kamal/hooks` directory. To use a hook:

1. Copy the relevant `.sample` file in the `.kamal/hooks` directory.
2. Remove the `.sample` extension from the copied file.
3. Modify the hook as needed for your deployment process.

Note: Active hook files (without the `.sample` extension) are gitignored to prevent committing sensitive information.

## Usage

See [API_DOCUMENTATION.md](API_DOCUMENTATION.md) for detailed API usage instructions.

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details.
