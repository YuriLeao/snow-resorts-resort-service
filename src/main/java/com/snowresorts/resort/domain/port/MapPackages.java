package com.snowresorts.resort.domain.port;

import com.snowresorts.resort.domain.model.MapPackage;
import java.util.Optional;
import java.util.UUID;

/** Outbound port for offline map packages. */
public interface MapPackages {

    Optional<MapPackage> findLatestByResortId(UUID resortId);
}
