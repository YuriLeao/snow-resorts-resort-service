-- Drop the unused offline map-package table. Offline maps are now handled entirely
-- on the mobile client via Mapbox's native offline packs (tile caching) plus locally
-- persisted trail/lift geometry, so the server no longer serves map packages.
SET search_path TO resorts, public;

DROP TABLE IF EXISTS resort_map_packages;
