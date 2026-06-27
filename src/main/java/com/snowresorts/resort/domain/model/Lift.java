package com.snowresorts.resort.domain.model;

import java.util.List;
import java.util.UUID;

/** A ski lift line, geometry as an ordered list of {@code [lng, lat]} coordinate pairs. */
public record Lift(
        UUID id,
        UUID resortId,
        String name,
        List<double[]> coordinates) {
}
