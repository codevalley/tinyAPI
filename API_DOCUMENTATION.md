# TinyAPI Documentation

TinyAPI is a simple storage service that allows users to save and edit payloads through a RESTful API. For now, it is still WIP and would support authentication based rate limits in future. 

## API Versioning

The API is versioned using URL namespacing. The current version is v1.

Base URL: `/api/v1`

## Authentication

All requests must include a client token in the header for client identification.
Header: `X-Client-Token: <token>`

Note: In v1, this token is a placeholder with no validation.

## Endpoints

### 1. Add Payload

**POST /api/v1/payloads**

Add a new payload to the system.

#### Request Body
