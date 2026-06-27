package com.snowresorts.resort.infrastructure.web;

import com.snowresorts.resort.domain.model.Resort;
import java.math.BigDecimal;
import java.util.UUID;

/** Lightweight catalog list item. */
public record ResortSummary(
        UUID id,
        String slug,
        String name,
        String country,
        double lat,
        double lng,
        BigDecimal avgRating,
        int reviewCount) {

    public static ResortSummary from(Resort resort) {
        return new ResortSummary(
                resort.id(),
                resort.slug(),
                resort.name(),
                resort.country(),
                resort.lat(),
                resort.lng(),
                resort.avgRating(),
                resort.reviewCount());
    }
}
