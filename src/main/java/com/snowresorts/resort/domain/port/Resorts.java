package com.snowresorts.resort.domain.port;

import com.snowresorts.resort.domain.model.Resort;
import java.math.BigDecimal;
import java.util.Optional;
import java.util.UUID;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;

/** Outbound port for reading the resort catalog and maintaining cached review aggregates. */
public interface Resorts {

    Optional<Resort> findById(UUID id);

    /**
     * Paginated catalog search. {@code country} (ISO-3166 alpha-2), free-text {@code q}
     * (name/slug/country) and the spatial filter (all of {@code lat}/{@code lng}/{@code radiusMeters})
     * are optional and combine with AND.
     */
    Page<Resort> search(String country, String q, Double lat, Double lng, Double radiusMeters,
                        Pageable pageable);

    /** Recomputes and persists the cached rating aggregate on a resort. */
    void updateAggregate(UUID resortId, BigDecimal avgRating, int reviewCount);
}
