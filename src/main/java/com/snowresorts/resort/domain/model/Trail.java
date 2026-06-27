package com.snowresorts.resort.domain.model;

import java.util.List;
import java.util.UUID;

/**
 * A marked ski trail. The geometry is kept domain-clean as an ordered list of
 * {@code [lng, lat]} coordinate pairs (decoded from the PostGIS {@code LineString}).
 */
public record Trail(
        UUID id,
        UUID resortId,
        String name,
        Difficulty difficulty,
        List<double[]> coordinates) {
}
