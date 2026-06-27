package com.snowresorts.resort.application;

import com.snowresorts.resort.domain.port.MapPackages;
import com.snowresorts.resort.infrastructure.web.MapPackageResponse;
import com.snowresorts.security.error.ResourceNotFoundException;
import java.util.UUID;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

/** Read-side use case for resolving the latest offline map package of a resort. */
@Service
public class MapPackageService {

    private final MapPackages mapPackages;

    public MapPackageService(MapPackages mapPackages) {
        this.mapPackages = mapPackages;
    }

    @Transactional(readOnly = true)
    public MapPackageResponse latest(UUID resortId) {
        return mapPackages.findLatestByResortId(resortId)
                .map(MapPackageResponse::from)
                .orElseThrow(() -> new ResourceNotFoundException(
                        "No map package found for resort '%s'.".formatted(resortId)));
    }
}
