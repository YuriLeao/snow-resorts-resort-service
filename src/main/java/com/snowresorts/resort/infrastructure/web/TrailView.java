package com.snowresorts.resort.infrastructure.web;

import com.snowresorts.resort.domain.model.Trail;
import java.util.List;
import java.util.UUID;

/** GeoJSON-ish trail view: identity, grade and an ordered list of {@code [lng, lat]} pairs. */
public record TrailView(
        UUID id,
        String name,
        String difficulty,
        List<double[]> coordinates) {

    public static TrailView from(Trail trail) {
        return new TrailView(
                trail.id(),
                trail.name(),
                trail.difficulty().code(),
                trail.coordinates());
    }
}
