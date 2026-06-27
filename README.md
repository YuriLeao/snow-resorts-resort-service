# snow-resorts-resort-service

Resort microservice for Snow Resorts: resort catalog, PostGIS trails/lifts, map packages
and user reviews (rating 1-5, one per user per resort).

- **Port:** 8083
- **DB schema:** `resorts`
- **Shared libs:** `com.snowresorts:security-lib` (from GitHub Packages)
- **Spatial:** PostGIS + hibernate-spatial + JTS

## Build & test

Requires a `github` server credential in `~/.m2/settings.xml` (see
[`settings.xml.example`](settings.xml.example)) to resolve the shared libraries.

```bash
./mvnw clean verify
./mvnw spring-boot:run    # `local` profile against the local Docker stack
```

Bring up Postgres/Redis/MinIO from [`snow-resorts-infra`](https://github.com/yurileao/snow-resorts-infra) (`make dev`).

## CI/CD

See [`.github/workflows/ci-cd.yml`](.github/workflows/ci-cd.yml). Requires repo secret
`AWS_DEPLOY_ROLE_ARN`.
