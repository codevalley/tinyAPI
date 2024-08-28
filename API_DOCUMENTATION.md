# TinyAPI Documentation

TinyAPI is a simple storage service that allows users to save and edit payloads through a RESTful API. For now, it is still WIP and would support authentication based rate limits in future. 

## Authentication

All requests must include a client token in the header for client identification.
Header: `X-Client-Token: <token>`

Note: In v1, this token is a placeholder with no validation.

## Endpoints

### 1. Add Payload

  ```bash
  curl -X POST http://localhost:3000/api/v1/add \
  -H "Content-Type: application/json" \
  -H "X-Client-Token: surface_token" \
  -d '{
    "payload": {
      "content": "Hello, world!",
      "mime_type": "text/plain",
      "expiry_time": "2024-01-01T00:00:00Z"
    }
  }'
  ```
### 2. Get Payload

  ```bash
  curl -X GET http://localhost:3000/api/v1/get/540331c86f1f77f9ff53   -H "X-Client-Token: surface_curl"
  ```

## Sample Requests

### Add Payload
