# Deploying TinyAPI with Kamal

This document outlines the steps to deploy TinyAPI using Kamal, a deployment tool for Ruby on Rails applications.

## Prerequisites

- Ruby 3.3.4
- Rails 7.2.1
- Redis
- Docker
- Kamal

## Setup

1. Install Kamal on your local machine:
   ```bash
   gem install kamal
   ```

2. Set up your `.env` file with the necessary environment variables (see `.env.example` for required variables).

3. Ensure your `config/deploy.yml` file is set up correctly, referencing environment variables for sensitive information.

4. Add both `.env` and `config/deploy.yml` to your `.gitignore` file to prevent committing sensitive information.

## Deployment Steps

1. Build your Docker image:
   ```bash
   docker build -t $DOCKER_USERNAME/tinyapi:latest .
   ```

2. Push your Docker image to the registry:
   ```bash
   docker push $DOCKER_USERNAME/tinyapi:latest
   ```

3. Set up the deployment environment:
   ```bash
   kamal setup
   ```

4. Deploy your application:
   ```bash
   kamal deploy
   ```

## Troubleshooting

- If you encounter connection issues, ensure you can SSH into your server using the IP specified in your `.env` file.
- Use the `-v` flag with Kamal commands for verbose output:
  ```bash
  kamal deploy -v
  ```

## Updating the Deployment

To update your deployment after making changes:

1. Rebuild and push your Docker image.
2. Run `kamal deploy` again.

## Security Considerations

- Keep all sensitive information in the `.env` file, which should not be checked into version control.
- Use environment variables in `config/deploy.yml` to reference sensitive information.
- Consider using a secrets management system for production deployments.

## Monitoring and Maintenance

- Check the application status:
  ```bash
  kamal app status
  ```

- View application logs:
  ```bash
  kamal app logs
  ```

- Restart the application:
  ```bash
  kamal app restart
  ```