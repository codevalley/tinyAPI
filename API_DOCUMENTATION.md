# TinyAPI Documentation

TinyAPI is a simple storage service that allows users to save and edit payloads through a RESTful API. It's currently a work in progress and will support authentication-based rate limits in the future.

## API Versioning

The API is versioned using URL namespacing. The current version is v1.

Base URL: `/api/v1`

## Authentication

All requests must include a client token in the header for client identification.
Header: `X-Client-Token: <token>`

Note: In v1, this token is a placeholder with no validation but is used for rate limiting.

## Rate Limiting

The API implements rate limiting based on the client token and the specific action. Current limits are:
- Create: 100 requests per hour
- Update: 200 requests per hour
- Show: 1000 requests per hour
- Default: 50 requests per hour for any other action

## Endpoints

### 1. Add Payload

**POST /api/v1/payloads**

Add a new payload to the system.

#### Request Body

```json
{
  "payload": {
    "content": "Your payload content here",
    "mime_type": "text/plain",
    "expiry_time": "2024-03-14T12:00:00Z"
  }
}
```

#### Response

```json
{
  "hash_id": "75ae7b2459c7cbd53cc7",
  "content": "Your payload content here",
  "mime_type": "text/plain",
  "created_at": "2024-08-30T06:39:26.692Z",
  "updated_at": "2024-08-30T06:39:26.692Z",
  "viewed_at": null,
  "expiry_time": "2024-03-14T12:00:00.000Z"
}
```

#### Sample curl command

```bash
curl -X POST http://localhost:3000/api/v1/payloads \
     -H "Content-Type: application/json" \
     -H "X-Client-Token: your_client_token" \
     -d '{
       "payload": {
         "content": "This is a test payload",
         "mime_type": "text/plain",
         "expiry_time": "2024-03-14T12:00:00Z"
       }
     }'
```

### 2. Update Payload

**PUT /api/v1/payloads/:hash_id**

Update an existing payload.

#### Request Body

```json
{
  "payload": {
    "content": "Your updated payload content here",
    "mime_type": "text/plain",
    "expiry_time": "2024-03-14T12:00:00Z"
  }
}
```

#### Response

```json
{
  "hash_id": "75ae7b2459c7cbd53cc7",
  "content": "Your updated payload content here",
  "mime_type": "text/plain",
  "created_at": "2024-08-30T06:39:26.692Z",
  "updated_at": "2024-08-30T07:00:00.000Z",
  "viewed_at": null,
  "expiry_time": "2024-03-14T12:00:00.000Z"
}
```

#### Sample curl command

```bash
curl -X PUT http://localhost:3000/api/v1/payloads/75ae7b2459c7cbd53cc7 \
     -H "Content-Type: application/json" \
     -H "X-Client-Token: your_client_token" \
     -d '{
       "payload": {
         "content": "This is an updated test payload",
         "mime_type": "text/plain",
         "expiry_time": "2024-03-14T12:00:00Z"
       }
     }'
```

### 3. Get Payload

**GET /api/v1/payloads/:hash_id**

Retrieve a payload by its hash_id.

#### Response

```json
{
  "hash_id": "75ae7b2459c7cbd53cc7",
  "content": "Your payload content here",
  "mime_type": "text/plain",
  "created_at": "2024-08-30T06:39:26.692Z",
  "updated_at": "2024-08-30T06:39:26.692Z",
  "viewed_at": "2024-08-30T07:15:00.000Z",
  "expiry_time": "2024-03-14T12:00:00.000Z"
}
```

#### Sample curl command

```bash
curl -X GET http://localhost:3000/api/v1/payloads/75ae7b2459c7cbd53cc7 \
     -H "X-Client-Token: your_client_token"
```

## Error Responses

The API may return the following error responses:

- 404 Not Found: When a requested payload doesn't exist
- 422 Unprocessable Entity: When the request body is invalid
- 429 Too Many Requests: When the rate limit is exceeded

Example error response:

```json
{
  "error": "Rate limit exceeded"
}
```

## Notes

- The `viewed_at` field is updated each time a payload is retrieved.
- Payloads are automatically deleted when their `expiry_time` is reached.
- The maximum payload size is 1 MB.