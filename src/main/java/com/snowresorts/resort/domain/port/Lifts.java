package com.snowresorts.resort.domain.port;

import com.snowresorts.resort.domain.model.Lift;
import java.util.List;
import java.util.UUID;

/** Outbound port for reading a resort's lifts. */
public interface Lifts {

    List<Lift> findByResortId(UUID resortId);

    /** All lifts whose geometry lies within {@code radiusMeters} of the given point. */
    List<Lift> findWithinRadius(double lat, double lng, double radiusMeters);
}
