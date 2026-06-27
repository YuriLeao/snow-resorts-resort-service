package com.snowresorts.resort.application;

import com.snowresorts.resort.domain.model.Resort;
import com.snowresorts.resort.domain.port.Lifts;
import com.snowresorts.resort.domain.port.Resorts;
import com.snowresorts.resort.domain.port.Trails;
import com.snowresorts.resort.infrastructure.web.NearbyGeometry;
import com.snowresorts.resort.infrastructure.web.PageResponse;
import com.snowresorts.resort.infrastructure.web.ResortDetail;
import com.snowresorts.resort.infrastructure.web.ResortSummary;
import com.snowresorts.security.error.ResourceNotFoundException;
import java.util.UUID;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

/** Read-side use cases for the public resort catalog (list, spatial search and detail). */
@Service
public class ResortQueryService {

    private final Resorts resorts;
    private final Trails trails;
    private final Lifts lifts;

    public ResortQueryService(Resorts resorts, Trails trails, Lifts lifts) {
        this.resorts = resorts;
        this.trails = trails;
        this.lifts = lifts;
    }

    @Transactional(readOnly = true)
    public PageResponse<ResortSummary> list(String country, String q, Double lat, Double lng,
                                            Double radiusMeters, Pageable pageable) {
        Page<Resort> page = resorts.search(country, q, lat, lng, radiusMeters, pageable);
        return PageResponse.from(page.map(ResortSummary::from));
    }

    @Transactional(readOnly = true)
    public ResortDetail detail(UUID id) {
        Resort resort = resorts.findById(id)
                .orElseThrow(() -> ResourceNotFoundException.of("Resort", id));
        return ResortDetail.from(resort, trails.findByResortId(id), lifts.findByResortId(id));
    }

    /**
     * Every trail and lift within {@code radiusKm} of the resort's coordinate (across all
     * resorts), so the map can show linked/neighbouring ski areas around the selected resort.
     */
    @Transactional(readOnly = true)
    public NearbyGeometry nearbyGeometry(UUID id, double radiusKm) {
        Resort resort = resorts.findById(id)
                .orElseThrow(() -> ResourceNotFoundException.of("Resort", id));
        double radiusMeters = radiusKm * 1000d;
        return NearbyGeometry.of(
                resort.id(),
                resort.lat(),
                resort.lng(),
                radiusKm,
                trails.findWithinRadius(resort.lat(), resort.lng(), radiusMeters),
                lifts.findWithinRadius(resort.lat(), resort.lng(), radiusMeters));
    }
}
