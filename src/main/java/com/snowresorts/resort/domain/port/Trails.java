package com.snowresorts.resort.domain.port;

import com.snowresorts.resort.domain.model.Trail;
import java.util.List;
import java.util.UUID;

/** Outbound port for reading a resort's trails. */
public interface Trails {

    List<Trail> findByResortId(UUID resortId);

    /** All trails whose geometry lies within {@code radiusMeters} of the given point. */
    List<Trail> findWithinRadius(double lat, double lng, double radiusMeters);
}
