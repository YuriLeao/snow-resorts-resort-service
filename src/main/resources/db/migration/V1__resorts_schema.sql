-- resorts schema: catalog, PostGIS trails/lifts, reviews and offline map packages.
-- Requires the PostGIS extension (provided by the postgis/postgis image / RDS PostGIS).
CREATE EXTENSION IF NOT EXISTS postgis;
SET search_path TO resorts, public;

CREATE TABLE resorts (
    id           UUID PRIMARY KEY,
    slug         VARCHAR(120) NOT NULL UNIQUE,
    name         VARCHAR(200) NOT NULL,
    country      VARCHAR(2)   NOT NULL,
    lat          DOUBLE PRECISION NOT NULL,
    lng          DOUBLE PRECISION NOT NULL,
    official_url VARCHAR(512),
    description  TEXT,
    avg_rating   NUMERIC(3,2) NOT NULL DEFAULT 0,
    review_count INTEGER      NOT NULL DEFAULT 0,
    created_at   TIMESTAMPTZ  NOT NULL DEFAULT now(),
    updated_at   TIMESTAMPTZ  NOT NULL DEFAULT now()
);

CREATE TABLE trails (
    id         UUID PRIMARY KEY,
    resort_id  UUID NOT NULL REFERENCES resorts(id) ON DELETE CASCADE,
    name       VARCHAR(200) NOT NULL,
    difficulty VARCHAR(20)  NOT NULL,  -- green|blue|black|red
    geom       geometry(LineString,4326)
);
CREATE INDEX idx_trails_geom ON trails USING GIST (geom);
CREATE INDEX idx_trails_resort ON trails (resort_id);

CREATE TABLE lifts (
    id        UUID PRIMARY KEY,
    resort_id UUID NOT NULL REFERENCES resorts(id) ON DELETE CASCADE,
    name      VARCHAR(200) NOT NULL,
    geom      geometry(LineString,4326)
);
CREATE INDEX idx_lifts_geom ON lifts USING GIST (geom);

CREATE TABLE resort_reviews (
    id         UUID PRIMARY KEY,
    resort_id  UUID NOT NULL REFERENCES resorts(id) ON DELETE CASCADE,
    user_id    UUID NOT NULL,
    rating     SMALLINT NOT NULL CHECK (rating BETWEEN 1 AND 5),
    title      VARCHAR(200),
    comment    TEXT,
    visited_at DATE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    UNIQUE (resort_id, user_id)
);
CREATE INDEX idx_reviews_resort ON resort_reviews (resort_id);

CREATE TABLE resort_map_packages (
    resort_id  UUID NOT NULL REFERENCES resorts(id) ON DELETE CASCADE,
    version    INTEGER NOT NULL,
    s3_key     VARCHAR(512) NOT NULL,
    checksum   VARCHAR(128),
    size_bytes BIGINT,
    PRIMARY KEY (resort_id, version)
);
