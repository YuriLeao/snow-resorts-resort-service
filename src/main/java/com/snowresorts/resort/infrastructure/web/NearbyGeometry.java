package com.snowresorts.resort.infrastructure.web;

import com.snowresorts.resort.domain.model.Lift;
import com.snowresorts.resort.domain.model.Trail;
import java.util.List;
import java.util.UUID;

/**
 * Aggregated trail/lift geometry within a radius of a resort — every piste and lift near the
 * point, across all resorts, so the map can render linked/neighbouring ski areas (e.g. the
 * Chilean Tres Valles) together rather than just the selected resort's own runs.
 */
public record NearbyGeometry(
        UUID resortId,
        double lat,
        double lng,
        double radiusKm,
        List<TrailView> trails,
        List<LiftView> lifts) {

    public static NearbyGeometry of(UUID resortId, double lat, double lng, double radiusKm,
                                    List<Trail> trails, List<Lift> lifts) {
        return new NearbyGeometry(
                resortId,
                lat,
                lng,
                radiusKm,
                trails.stream().map(TrailView::from).toList(),
                lifts.stream().map(LiftView::from).toList());
    }
}
