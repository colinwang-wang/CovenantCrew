# Mock Rules

## Principle

Mocking is allowed only when an external dependency is unavailable or explicitly out of scope for the current phase.

## Allowed Mocks

| Feature | Reason | Owner | Removal Condition |
|---|---|---|---|
|  |  |  |  |

## Required Labels

Code mocks must include a visible marker:

```text
MOCK: explain why this is mocked and when to replace it
```

## Not Allowed

- Fake success for core business flows
- Buttons that only show "coming soon" for approved P0 scope
- Hardcoded API responses without an entry in this file

