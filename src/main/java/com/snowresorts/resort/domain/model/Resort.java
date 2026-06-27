package com.snowresorts.resort.domain.model;

import java.math.BigDecimal;
import java.util.UUID;

/**
 * A ski resort catalog entry. Aggregate ratings ({@code avgRating}/{@code reviewCount}) are
 * cached denormalised values recomputed whenever a review is created, updated or removed.
 * Domain model: never exposed directly on the API.
 */
public record Resort(
        UUID id,
        String slug,
        String name,
        String country,
        double lat,
        double lng,
        String officialUrl,
        String description,
        BigDecimal avgRating,
        int reviewCount) {
}
