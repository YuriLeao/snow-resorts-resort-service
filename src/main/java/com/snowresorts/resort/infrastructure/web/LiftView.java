package com.snowresorts.resort.infrastructure.web;

import com.snowresorts.resort.domain.model.Lift;
import java.util.List;
import java.util.UUID;

/** GeoJSON-ish lift view: identity and an ordered list of {@code [lng, lat]} pairs. */
public record LiftView(
        UUID id,
        String name,
        List<double[]> coordinates) {

    public static LiftView from(Lift lift) {
        return new LiftView(lift.id(), lift.name(), lift.coordinates());
    }
}
