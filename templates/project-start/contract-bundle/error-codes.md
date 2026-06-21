# Error Code Contract

## Response Format

```json
{
  "code": 0,
  "message": "ok",
  "data": {}
}
```

## Ranges

| Range | Meaning |
|---|---|
| 0 | Success |
| 10xxx | Common validation/auth errors |
| 20xxx | Business rule errors |
| 30xxx | System/external dependency errors |

## Codes

| Code | Message | HTTP Status | Meaning | Frontend Handling |
|---|---|---|---|---|
| 0 | ok | 200 | Success | Continue |
| 10001 | unauthorized | 401 | Missing or invalid login | Redirect to login |

