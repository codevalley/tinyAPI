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

- Ruby 3.x
- Rails 7.2.1
- Redis

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

## Usage

See [API_DOCUMENTATION.md](API_DOCUMENTATION.md) for detailed API usage instructions.

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details.
