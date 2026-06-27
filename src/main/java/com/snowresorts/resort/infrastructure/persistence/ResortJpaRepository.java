package com.snowresorts.resort.infrastructure.persistence;

import java.util.UUID;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

public interface ResortJpaRepository extends JpaRepository<ResortEntity, UUID> {

    @Query("""
            SELECT r FROM ResortEntity r
            WHERE (:country IS NULL OR r.country = :country)
            """)
    Page<ResortEntity> listCatalog(@Param("country") String country, Pageable pageable);

    /**
     * Catalog search with optional ISO country and case-insensitive text match on name, slug or country.
     */
    @Query("""
            SELECT r FROM ResortEntity r
            WHERE (:country IS NULL OR r.country = :country)
              AND (LOWER(r.name) LIKE LOWER(:qPattern)
                OR LOWER(r.slug) LIKE LOWER(:qPattern)
                OR LOWER(r.country) LIKE LOWER(:qPattern))
            """)
    Page<ResortEntity> searchCatalog(@Param("country") String country,
                                     @Param("qPattern") String qPattern,
                                     Pageable pageable);

    /**
     * Spatial "resorts near a point" search using PostGIS {@code ST_DWithin} on geography (metres),
     * with optional ISO country filter. A native query is used because geography distance
     * is a PostGIS function with no JPQL equivalent; a GIST index backs the predicate at scale.
     */
    @Query(value = """
            SELECT * FROM resorts.resorts r
            WHERE ST_DWithin(
                    geography(ST_SetSRID(ST_MakePoint(r.lng, r.lat), 4326)),
                    geography(ST_SetSRID(ST_MakePoint(:lng, :lat), 4326)),
                    :radiusMeters)
              AND (:country IS NULL OR r.country = :country)
            """,
            countQuery = """
            SELECT count(*) FROM resorts.resorts r
            WHERE ST_DWithin(
                    geography(ST_SetSRID(ST_MakePoint(r.lng, r.lat), 4326)),
                    geography(ST_SetSRID(ST_MakePoint(:lng, :lat), 4326)),
                    :radiusMeters)
              AND (:country IS NULL OR r.country = :country)
            """,
            nativeQuery = true)
    Page<ResortEntity> listNear(@Param("lat") double lat,
                                @Param("lng") double lng,
                                @Param("radiusMeters") double radiusMeters,
                                @Param("country") String country,
                                Pageable pageable);

    /**
     * {@link #listNear} with an additional case-insensitive text match on name, slug or country.
     */
    @Query(value = """
            SELECT * FROM resorts.resorts r
            WHERE ST_DWithin(
                    geography(ST_SetSRID(ST_MakePoint(r.lng, r.lat), 4326)),
                    geography(ST_SetSRID(ST_MakePoint(:lng, :lat), 4326)),
                    :radiusMeters)
              AND (:country IS NULL OR r.country = :country)
              AND (LOWER(r.name) LIKE LOWER(:qPattern)
                OR LOWER(r.slug) LIKE LOWER(:qPattern)
                OR LOWER(r.country) LIKE LOWER(:qPattern))
            """,
            countQuery = """
            SELECT count(*) FROM resorts.resorts r
            WHERE ST_DWithin(
                    geography(ST_SetSRID(ST_MakePoint(r.lng, r.lat), 4326)),
                    geography(ST_SetSRID(ST_MakePoint(:lng, :lat), 4326)),
                    :radiusMeters)
              AND (:country IS NULL OR r.country = :country)
              AND (LOWER(r.name) LIKE LOWER(:qPattern)
                OR LOWER(r.slug) LIKE LOWER(:qPattern)
                OR LOWER(r.country) LIKE LOWER(:qPattern))
            """,
            nativeQuery = true)
    Page<ResortEntity> searchNear(@Param("lat") double lat,
                                  @Param("lng") double lng,
                                  @Param("radiusMeters") double radiusMeters,
                                  @Param("country") String country,
                                  @Param("qPattern") String qPattern,
                                  Pageable pageable);
}
