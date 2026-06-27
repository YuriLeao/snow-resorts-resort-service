package com.snowresorts.resort.infrastructure.web;

import com.snowresorts.resort.domain.model.Lift;
import com.snowresorts.resort.domain.model.Resort;
import com.snowresorts.resort.domain.model.Trail;
import java.math.BigDecimal;
import java.util.List;
import java.util.UUID;

/** Full resort view including aggregates and decoded trail/lift geometry. */
public record ResortDetail(
        UUID id,
        String slug,
        String name,
        String country,
        double lat,
        double lng,
        String officialUrl,
        String description,
        BigDecimal avgRating,
        int reviewCount,
        List<TrailView> trails,
        List<LiftView> lifts) {

    public static ResortDetail from(Resort resort, List<Trail> trails, List<Lift> lifts) {
        return new ResortDetail(
                resort.id(),
                resort.slug(),
                resort.name(),
                resort.country(),
                resort.lat(),
                resort.lng(),
                resort.officialUrl(),
                resort.description(),
                resort.avgRating(),
                resort.reviewCount(),
                trails.stream().map(TrailView::from).toList(),
                lifts.stream().map(LiftView::from).toList());
    }
}
