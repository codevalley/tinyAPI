# TinyAPI Documentation

TinyAPI is a simple storage service that allows users to save and edit payloads through a RESTful API. For now, it is still WIP and would support authentication based rate limits in future. 

## Authentication

All requests must include a client token in the header for client identification.
Header: `X-Client-Token: <token>`

Note: In v1, this token is a placeholder with no validation.

## Endpoints

### 1. Add Payload

- **URL:** `/api/v1/add`
- **Method:** POST
- **Headers:**
  - Content-Type: application/json
  - X-Client-Token: <your_client_token>
- **Body:**
  ```json
  {
    "payload": {
      "content": "Your content here",
      "mime_type": "text/plain",
      "expiry_time": "YYYY-MM-DDTHH:MM:SSZ"
    }
  }
  ```
- **Response:** JSON with hash_id, created_at timestamp, and other metadata
- **Rate limit:** 100 requests per hour per client token

### 2. Edit Payload

- **URL:** `/api/v1/edit/:hash_id`
- **Method:** PUT
- **Headers:**
  - Content-Type: application/json
  - X-Client-Token: <your_client_token>
- **Body:**
  ```json
  {
    "payload": {
      "content": "Your updated content here",
      "mime_type": "text/plain",
      "expiry_time": "YYYY-MM-DDTHH:MM:SSZ"
    }
  }
  ```
- **Response:** Updated metadata
- **Rate limit:** 200 requests per hour per client token

### 3. Get Payload

- **URL:** `/api/v1/get/:hash_id`
- **Method:** GET
- **Headers:**
  - X-Client-Token: <your_client_token>
- **Response:** Payload content and metadata
- **Rate limit:** 1000 requests per hour per client token

## Notes

- Maximum payload size: 1 MB
- Payloads are automatically deleted when their expiry time is reached or if not viewed for 6 days
- Expiry time is limited to a maximum set by the server configuration