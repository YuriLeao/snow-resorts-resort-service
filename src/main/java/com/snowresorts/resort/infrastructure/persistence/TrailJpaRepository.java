package com.snowresorts.resort.infrastructure.persistence;

import java.util.List;
import java.util.UUID;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

public interface TrailJpaRepository extends JpaRepository<TrailEntity, UUID> {

    List<TrailEntity> findByResortId(UUID resortId);

    /**
     * Trails whose geometry lies within {@code radiusMeters} of a point, regardless of which
     * resort they belong to. Native query because the geography distance predicate
     * ({@code ST_DWithin}) is a PostGIS function with no JPQL equivalent; the GIST index on
     * {@code geom} backs it at scale.
     */
    @Query(value = """
            SELECT * FROM resorts.trails t
            WHERE t.geom IS NOT NULL
              AND ST_DWithin(
                    ST_SetSRID(t.geom, 4326)::geography,
                    ST_SetSRID(ST_MakePoint(:lng, :lat), 4326)::geography,
                    :radiusMeters)
            """,
            nativeQuery = true)
    List<TrailEntity> findWithinRadius(@Param("lat") double lat,
                                       @Param("lng") double lng,
                                       @Param("radiusMeters") double radiusMeters);
}
